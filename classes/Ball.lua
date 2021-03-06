local physics = require('physics')

-- Default properties
local Ball = { }

-- Function: Ball:new
-- Description: Constructor
function Ball:new ( obj )
	obj = obj or {}
	setmetatable( obj, self )
	self.__index = self
	return obj
end

-- Function: onCollision
-- Description: Collision listener
local function onCollision( event )
	if ( event.phase == 'began' ) then
		if ( event.other.tag == 'ballBounds' ) then

			event.target.parentObject:remove()

		end
	end
end

-- Function: Ball:spawn
-- Description: Init object
function Ball:spawn( dx, dy, power )
	self.shape = display.newCircle( display.contentCenterX, display.contentHeight, 10 )

	-- Define Ball's collision filter:
		-- Cat. 1: Ball
		-- Collides with: 2 (blocks) + 4 (pickups)
	physics.addBody( self.shape, 'dynamic', { filter = { categoryBits = 1, maskBits = 14 } } )
	self.shape.tag = 'ball'
	self.shape.parentObject = self
	self.shape:addEventListener( 'collision', onCollision )
	self.shape.isFixedRotation = true
	self.shape.gravityScale = 0

	self.shape:setLinearVelocity( dx, dy )
end

-- Function: Ball:setActive
-- Description: Used to play/pause obj
function Ball:setActive( active )
	if active then 	-- Set to play
		-- Reset the velocity
		self.shape:setLinearVelocity( self.dx, self.dy )
		self.shape.alpha = 1
	else 	-- Set to pause
		-- Store the velocity and stop
		local x, y = self.shape:getLinearVelocity( )
		self.dx = x
		self.dy = y
		self.shape:setLinearVelocity( 0, 0 )	
		self.shape.alpha = 0
	end
end

-- Function: Ball:remove
-- Description: Deconstructor
function Ball:remove(  )
	self.shape:removeSelf( )
	self.shape = nil
	self = nil
end

return Ball
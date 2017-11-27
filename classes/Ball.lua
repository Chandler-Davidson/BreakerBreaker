local physics = require('physics')
physics.start( )
physics.setGravity( 0, 0 ) 

local Ball = { }

function Ball:new ( obj )
	obj = obj or {}
	setmetatable( obj, self )
	self.__index = self
	return obj
end

local function onCollision( event )
	if ( event.phase == 'began' ) then
		if ( event.other.tag == 'block' ) then
		
		elseif ( event.other.tag == 'ballBounds' ) then

			event.target.parentObject:remove()

		end
	end
end

function Ball:spawn( dx, dy, power )
	self.shape = display.newCircle( display.contentCenterX, display.contentHeight, 15 )

	-- Define Ball's collision filter:
		-- Cat. 1: Ball
		-- Cat. 2: Blocks and Walls
	physics.addBody( self.shape, 'dynamic', { filter = { categoryBits = 1, maskBits = 2 } } )
	self.shape.tag = 'ball'
	self.shape.parentObject = self
	self.shape:addEventListener( 'collision', onCollision )
	self.shape.isFixedRotation = true

	-- Needs to be calculated
	-- self.shape:setLinearVelocity( -100, -500 )
	self.shape:setLinearVelocity( dx, dy )
end

function Ball:remove(  )
	self.shape:removeSelf( )
	self.shape = nil
	self = nil

	print( 'Ball removed' )
end

return Ball
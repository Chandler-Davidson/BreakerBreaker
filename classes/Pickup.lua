local physics = require('physics')
physics.start( )

-- Default Properties
local Pickup = { pickupType = 'Ball', color = { 0, 0, 1 }, notification = '+1 Ball' }

-- Function: Pickup:new
-- Description: Constructor
function Pickup:new( obj )
	obj = obj or {}
	setmetatable( obj, self )
	self.__index = self
	return obj
end

-- Function: onCollision
-- Description: Collision Listener
local function onCollision( event )

	-- Easier reference to the main obj
	-- 	 Clarification: event.target = display obj NOT our Pickup obj
	--   event.target.parentObject = our Pickup obj
	local self = event.target.parentObject

	if ( event.phase == 'began' ) then

		if ( event.other.tag == 'ball' ) then

			-- Call scene to apply logic
			self.scene:applyPickup( self.pickupType )
			self:displayNotification()
			self:remove()

		elseif ( event.other.tag == 'block' ) then
			-- We don't want lingering pickups, so if they collide remove self
			print( '\t**Pickup removed, due to collision with block**' )
			self:remove()
		end
	end
end

-- Function: Pickup:spawn
-- Description: Init obj
function Pickup:spawn( scene )
	self.scene = scene	-- Connectino to game scene

	local xPos = math.random( 1, 7 ) * 40
	local yPos = math.random( 1, 10 ) * 40

	print( '  Spawning Pickup: ' )
	print( '\tNew ' .. self.pickupType .. ' Pickup' )

	self.shape = display.newCircle( xPos, yPos, 15 )

	self.shape:setFillColor( unpack( self.color ) )
	self.shape.strokeWidth = 1

	-- Define Ball's collision filter:
		-- Cat. 1: Pickup
		-- Collides with: 1 (balls) + 2 (blocks)
	physics.addBody( self.shape, 'dynamic', { 
		filter = { categoryBits = 4, maskBits = 3 }, 
		isSensor = true } )
	self.shape.gravityScale = 0
	self.shape.isFixedRotation = true
	-- Define as dynamic to allow collision with Block

	self.shape.tag = 'Pickup'
	self.shape.parentObject = self
	self.shape:addEventListener( 'collision', onCollision )
end

-- Function: Pickup:displayNotification
-- Description: Fades in/out text, ex. '+1 Ball'
function Pickup:displayNotification(  )
	local notification = display.newText( self.notification, self.shape.x, self.shape.y, native.systemFontBold, 20 )
	notification.alpha = 0

	transition.to( notification, { time = 400, alpha = .7, onComplete = function (  )
		transition.to( notification, { time = 400, alpha = 0 } )
	end } )
end

-- Function: Pickup:setAlpha
-- Description: Used to show/hide the obj
function Pickup:setAlpha( a )
	if self.shape then
		self.shape.alpha = a
	end
end

-- Function: Pickup:remove
-- Description: Deconstructor
function Pickup:remove( )
	self.shape:removeSelf( )
	self.shape = nil
	self = nil
end

return Pickup
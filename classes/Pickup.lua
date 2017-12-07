local physics = require('physics')
physics.start( )

local Pickup = { pickupType = 'Ball' }

function Pickup:new( obj )
	obj = obj or {}
	setmetatable( obj, self )
	self.__index = self
	return obj
end

local function onCollision( event )

	local self = event.target.parentObject

	if ( event.phase == 'began' ) then

		if ( event.other.tag == 'ball' ) then

			self.scene:applyPickup( self.pickupType )
			self:displayNotification()
			self:remove()

		elseif ( event.other.tag == 'block' ) then
			print( 'hit block' )
			self:remove()
		end
	end
end

function Pickup:spawn( scene )
	self.scene = scene	-- Connectino to game scene

	local xPos = math.random( 1, 7 ) * 40
	local yPos = math.random( 1, 10 ) * 40

	print( 'New Pickup Pos: ' .. xPos, yPos )

	self.shape = display.newCircle( xPos, yPos, 15 )

	self.shape:setFillColor( 0, 0, 1 )
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

function Pickup:displayNotification(  )
	local notification = display.newText( '+1 Ball', self.shape.x, self.shape.y, native.systemFontBold, 20 )
	notification.alpha = 0

	transition.to( notification, { time = 400, alpha = .7, onComplete = function (  )
		transition.to( notification, { time = 400, alpha = 0 } )
	end } )
end

function Pickup:remove( )
	self.shape:removeSelf( )
	self.shape = nil
	self = nil
end

return Pickup
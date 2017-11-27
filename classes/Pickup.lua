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
	if ( event.phase == 'began' ) then

		if ( event.other.tag == 'ball' ) then

			event.target.parentObject.scene:applyPickup( event.target.parentObject.pickupType )

			event.target.parentObject:remove()

		end
	end
end

function Pickup:spawn( scene )
	self.scene = scene

	local xPos = math.random( 1, 7 ) * 40
	local yPos = math.random( 1, 10 ) * 40

	print( 'New Pickup Pos: ' .. xPos, yPos )

	self.shape = display.newCircle( xPos, yPos, 20 )

	self.shape:setFillColor( 0, 0, 1 )
	self.shape.strokeWidth = 1

	physics.addBody( self.shape, 'kinematic', { filter = { categoryBits = 2, maskBits = 1 }, bounce = 1, isSensor = true } )
	self.shape.tag = 'Pickup'
	self.shape.parentObject = self
	self.shape:addEventListener( 'collision', onCollision )
end

function Pickup:remove( )
	self.shape:removeSelf( )
	self.shape = nil

	self = nil
end

return Pickup
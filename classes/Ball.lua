local physics = require('physics')
physics.start( )
physics.setGravity( 0, 0 ) 

local Ball = { comboCounter = 0 }

function Ball:new ( obj )
	obj = obj or {}
	setmetatable( obj, self )
	self.__index = self
	return obj
end

local function onCollision( event )
	if ( event.phase == 'began' ) then
		if ( event.other.tag == 'block' ) then

			event.target.parentObject.comboCounter = event.target.parentObject.comboCounter + 1
		
		elseif ( event.other.tag == 'ballBounds' ) then

			event.target.parentObject:remove()

		end
	end
end

function Ball:spawn( dx, dy, power )
	self.shape = display.newCircle( display.contentCenterX, display.contentHeight, 20 )

	physics.addBody( self.shape, 'dynamic' )
	self.shape.tag = 'ball'
	self.shape.parentObject = self
	self.shape:addEventListener( 'collision', onCollision )
	self.shape.isFixedRotation = true

	-- Needs to be calculated
	self.shape:setLinearVelocity( -400, -300 )
end

function Ball:remove(  )
	self.shape:removeSelf( )
	self.shape = nil
	self = nil

	print( 'Ball removed' )
end

return Ball
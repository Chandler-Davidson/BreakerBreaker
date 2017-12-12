local physics = require('physics')
local timer = require('timer')
physics.start( )

local Block = { hitPoints = 5 }

function Block:new( obj )
	obj = obj or {}
	setmetatable( obj, self )
	self.__index = self
	return obj
end

local function onCollision( event )
	if ( event.phase == 'began' ) then

		if ( event.other.tag == 'ball' ) then

			event.target.parentObject:hit()

		end
	end
end

function Block:spawn( xPos )
	-- local xPos = math.random( 1, 7 ) * 40
	-- local xPos = 1 * 40
	print( '\tNew Block HP: ' .. self.hitPoints )

	self.shape = display.newRect( xPos, 0, 40, 40 )
	self.shape:setFillColor( 1, 0, 0 )
	self.shape.strokeWidth = 5
	self.shape:setStrokeColor( 0 )
	self.shapeHealth = display.newText( {
		text = self.hitPoints,
		x = self.shape.x, y = self.shape.y,
		font = native.systemFontBold,
		fontSize = 35 } )
	-- Define Ball's collision filter:
		-- Cat. 2: Block
		-- Collides with: 1 (balls) + 4 (pickups)
	physics.addBody( self.shape, 'kinematic', { filter = { categoryBits = 2, maskBits = 5 }, bounce = 1 } )
	self.shape.gravityScale = 0
	self.shape.tag = 'block'
	self.shape.parentObject = self
	self.shape:addEventListener( 'collision', onCollision )
end

function Block:hit(  )
	self.hitPoints = self.hitPoints - 1

	if self.hitPoints <= 0 then
		self:remove( )
	else
		self.shapeHealth.text = self.hitPoints
	end
end

function Block:move(  )

	transition.to( self.shape, {
		y = self.shape.y + self.shape.height,
		time = 300
		} )

	transition.to( self.shapeHealth, {
		y = self.shapeHealth.y + self.shape.height,
		time = 300
		})
end

function Block:remove( )
	self.shape:removeSelf( )
	self.shape = nil

	self.shapeHealth:removeSelf( )
	self.shapeHealth = nil

	self = nil
end

return Block
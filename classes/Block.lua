local physics = require('physics')
local timer = require('timer')
physics.start( )

-- Default properties
local Block = { hitPoints = 5 }

-- Function: Block:new
-- Description: Constructor
function Block:new( obj )
	obj = obj or {}
	setmetatable( obj, self )
	self.__index = self
	return obj
end

-- Function: onCollision
-- Description: Collision Listener
local function onCollision( event )
	if ( event.phase == 'began' ) then
		if ( event.other.tag == 'ball' ) then
			event.target.parentObject:hit()
		end
	end
end

-- Function: Block:Spawn
-- Description: Init object
function Block:spawn( xPos )
	-- local xPos = math.random( 1, 7 ) * 40
	-- local xPos = 1 * 40
	print( '\tNew Block HP: ' .. self.hitPoints )

	--self.shape = display.newRect( xPos, 0, 40, 40 ) -- Main container
	self.shape = display.newRoundedRect( xPos, 0, 40, 40, 5 )
	self.shape:setFillColor( self:getColor() )

	self.shapeHealth = display.newText( { 	-- Number inside block
		text = self.hitPoints,
		x = self.shape.x, y = self.shape.y - 2,
		font = native.systemFontBold,
		fontSize = 35 } )

	if ( self.hitPoints >= 10) then 		-- Ensure # fits inside
		self.shapeHealth.size = 30
	end

	-- Define Ball's collision filter:
		-- Cat. 2: Block
		-- Collides with: 1 (balls) + 4 (pickups) + 2 (bottomWall)
	physics.addBody( self.shape, 'kinematic', { filter = { categoryBits = 2, maskBits = 13 }, bounce = 1 } )
	self.shape.tag = 'block'
	self.shape.parentObject = self
	self.shape:addEventListener( 'collision', onCollision )
end

-- Function: Block:hit
-- Description: If hit by a ball, lower HP
function Block:hit( hp )
	hp = hp or 1

	self.hitPoints = self.hitPoints - hp

	if self.hitPoints <= 0 then
		-- Delete block
		self:remove( )
	else
		self.shapeHealth.text = self.hitPoints			-- Update HP
		self.shape:setFillColor( self:getColor() )		-- Update color
	end
end

function Block:getColor( )
	local mult = 7
	local hp = self.hitPoints

	local r, b, g
	r = (48 - (hp * mult))/255
	b = (244 - (hp * mult * 2))/255
	g = (176 - (hp * mult))/255

	return r, b, g
end

-- Function: Block:move
-- Description: Smoothly lower the block
function Block:move(  )
	transition.to( self.shape, {
		y = self.shape.y + self.shape.height + 3,
		time = 300
		} )

	transition.to( self.shapeHealth, {
		y = self.shapeHealth.y + self.shape.height + 3,
		time = 300
		} )
end

-- Function: Block:setAlpha
-- Description: Used to show/hide the obj
function Block:setAlpha( a )
	if self.shape then
		self.shape.alpha = a
		self.shapeHealth.alpha = a
	end
end

-- Function: Block:remove
-- Description: Deconstructor
function Block:remove( )
	self.shape:removeSelf( )
	self.shape = nil

	self.shapeHealth:removeSelf( )
	self.shapeHealth = nil

	self = nil
end

return Block
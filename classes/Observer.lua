local Block = require('classes.Block')
local Pickup = require('classes.Pickup')

local Observer = {}

local inPlay = true
local holdingMove = false
local inQueueSpawnNumBlocks
local inQueueSpawnDifficulty
local inQueuePickup

-- Function: Observer:new
-- Description: Constructor
function Observer:new( obj )
	obj = obj or {}
	setmetatable( obj, self )
	self.__index = self
	return obj
end

-- Function: Observer:spawn
-- Description: Init obj
function Observer:spawn( scene )
	self.scene = scene
	self.blocks = {} -- Hold alive blocks
	self.pickups = {} -- Hold pickups
end

-- Function: Observer:spawnBlocks
-- Description: Spawns the number of specified blocks
function Observer:spawnBlocks( difficulty )
	if inPlay then

		-- First determin max. num of blocks
		local numBlocks
		if difficulty > 7 then 	-- Max of 7 blocks per row
			numBlocks = 7
		else
			numBlocks = difficulty
		end

		-- Determine the actual number of blocks
		numBlocks = math.random( numBlocks )

		local randNumbers = {}
		local tempNum

		for i = 1, numBlocks do
			-- Spaces 0 - 6 * (blockSize + padding) + padding between block and screen width
			tempNum = math.random( 0, 6 ) * 43 + 30

			if ( table.indexOf( randNumbers, tempNum ) == nil ) then
				-- Put new number into table
				randNumbers[i] = tempNum

				-- Spawn a new block, then insert into table
				local tempBlock = Block:new( { hitPoints = difficulty + math.random( 1, 5 ) } )
				tempBlock:spawn( randNumbers[i] )
				table.insert( self.blocks, tempBlock )
			end
 		end
		
	else
		inQueueSpawnNumBlocks = numBlocks
		inQueueSpawnDifficulty = difficulty
		holdingMove = true
	end
end

-- Function: Observer:spawnPickup
-- Description: Spawns a random pickup
function Observer:spawnPickup( )
	local pickupType = math.random( 2 )
	local tempPickup

	if ( pickupType == 1 ) then
		tempPickup = Pickup:new( { pickupType = "Ball", color = { 98/255, 168/255, 229/255 }, notification = "+1 Ball" } )
	else
		tempPickup = Pickup:new( { pickupType = "Shockwave", color = { 229/255, 105/255, 98/255 }, notification = "Boom" } )
	end

	if inPlay then
		tempPickup:spawn( self.scene )
		table.insert( self.pickups, tempPickup )
	else
		inQueuePickup = tempPickup
		holdingMove = true
	end

end

-- Function: Observer:refactor
-- Description: Resets the blocks{} removing any nil indexes
function Observer:refactor( list )
	local newT = {}

	for i=1,#list do
		if list[i] and list[i].shape then
			table.insert( newT, list[i] )
		end
	end

	list = newT
end

-- Function: Observer:moveBlocks
-- Description: Moves all active blocks down
function Observer:moveBlocks( )

	-- Clean up blocks
	self:refactor( self.blocks )

	-- Clean up pickups, because...
	self:refactor( self.pickups )

	if inPlay then
		-- Iterate through table
		for i = 1, #self.blocks do
			if self.blocks[i] and self.blocks[i].shape then
				self.blocks[i]:move()
			else
				-- Garbage collection
				self.blocks[i] = nil
			end
		end

	else
		holdingMove = true
	end
end

-- Function: Observer:hitAll
-- Description: Hits all active blocks
function Observer:hitAll( hitPoints )
	for i = 1, #self.blocks do
		if self.blocks[i] then
			self.blocks[i]:hit( hitPoints )
		end
	end
end

-- Function: Observer:setAlpha
-- Description: Hides/Shows all blocks
function Observer:setAlpha( a )
	self:refactor(self.blocks)
	self:refactor(self.pickups)

	for i = 1, #self.blocks do
		if ( self.blocks[i] ) then
			self.blocks[i]:setAlpha( a )
		end
	end

	for i = 1, #self.pickups do
		self.pickups[i]:setAlpha( a )
	end
end

function Observer:setInPlay( a )
	inPlay = a

	if inPlay and holdingMove then
		self:spawnBlocks( inQueueSpawnNumBlocks, inQueueSpawnDifficulty )
		self:moveBlocks()

		inQueuePickup:spawn( self.scene )
		table.insert(self.pickups, inQueuePickup)
		inQueuePickup = nil
	end
end

function Observer:setHoldingMove( a )
	holdingMove = a
end

return Observer
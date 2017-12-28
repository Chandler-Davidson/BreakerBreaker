local Block = require('classes.Block')
local Pickup = require('classes.Pickup')

local Observer = {}

local inPlay = true
local holdingMove = false
local inQueueSpawnNumBlocks
local inQueueSpawnDifficulty

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
function Observer:spawnBlocks( numBlocks, difficulty )
	if inPlay then

		print( '  Spawning Blocks:' )

			-- Generate random, non repeating locations
			local randNumbers = {}	-- Holds chosen locations 
			local tempNum

			-- Decide a random location for each block
			for i = 1, numBlocks do

				repeat
					tempNum = math.random( 1, 7 ) * 40

					if ( table.indexOf( randNumbers, tempNum ) == nil ) then

						-- Put new number into table
						randNumbers[i] = tempNum

						-- Spawn a new block, then insert into table
						local tempBlock = Block:new( { hitPoints = difficulty + math.random( 1, 5 ) } )
						tempBlock:spawn( randNumbers[i] )
						table.insert( self.blocks, tempBlock )

					end

				until randNumbers[i] ~= nil
			end
		else
			inQueueSpawnNumBlocks = numBlocks
			inQueueSpawnDifficulty = difficulty
			holdingMove = true
		end
end

-- Function: Observer:spawnPickup
-- Description: Spawns an instance of the specficic pickup
function Observer:spawnPickup( type )
	local strNote

	if ( type == "Ball" ) then
		strNote = "+1 Ball"
	else
		strNote = "Boom!"
	end

	Pickup:new( { pickupType = type, color = { 1, 0, 0 }, notification = strNote } ):spawn( self.scene )
end

-- Function: Observer:refactor
-- Description: Resets the blocks{} removing any nil indexes
function Observer:refactor( list )
	local newT = {}

	for i=1,#list do
		if list[i] ~= nil then
			table.insert( newT, list[i] )
		end
	end

	list = newT
end

-- Function: Observer:moveBlocks
-- Description: Moves all active blocks down
function Observer:moveBlocks( )

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

		-- Clean up blocks
		self:refactor( self.blocks )

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
	for i = 1, #self.blocks do
		self.blocks[i]:setAlpha( a )
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
	end
end

function Observer:setHoldingMove( a )
	holdingMove = a
end

return Observer
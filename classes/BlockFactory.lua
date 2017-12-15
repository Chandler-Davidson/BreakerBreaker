local Block = require('classes.Block')

local BlockFactory = {}

-- Function: BlockFactory:new
-- Description: Constructor
function BlockFactory:new( obj )
	obj = obj or {}
	setmetatable( obj, self )
	self.__index = self
	return obj
end

-- Function: BlockFactory:spawn
-- Description: Init obj
function BlockFactory:spawn(  )
	self.blocks = {} -- Hold alive blocks
end

-- Function: BlockFactory:spawnBlocks
-- Description: Spawns the number of specified blocks
function BlockFactory:spawnBlocks( numBlocks, difficulty )
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
end

-- Function: BlockFactory:refactor
-- Description: Resets the blocks{} removing any nil indexes
function BlockFactory:refactor(  )
	local newT = {}

	for i=1,#self.blocks do
		if self.blocks[i] ~= nil then
			table.insert( newT, self.blocks[i] )
		end
	end

	self.blocks = newT
end

-- Function: BlockFactory:moveBlocks
-- Description: Moves all active blocks down
function BlockFactory:moveBlocks( )
	-- Iterate through table
	for i = 1, #self.blocks do
		if self.blocks[i] and self.blocks[i].shape then
			self.blocks[i]:move()
		else
			-- Garbage collection
			self.blocks[i] = nil
		end
	end

	-- Clean up the table
	self:refactor()
end

-- Function: BlockFactory:hitAll
-- Description: Hits all active blocks
function BlockFactory:hitAll( hitPoints )
	for j = 1, hitPoints do
		for i = 1, #self.blocks do
			if self.blocks[i] then
				self.blocks[i]:hit()
			end
		end
	end
end

-- Function: BlockFactory:setAlpha
-- Description: Hides/Shows all blocks
function BlockFactory:setAlpha( a )
	for i = 1, #self.blocks do
		self.blocks[i]:setAlpha( a )
	end
end

return BlockFactory
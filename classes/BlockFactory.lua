local Block = require('classes.Block')

local BlockFactory = {}

function BlockFactory:new( obj )
	obj = obj or {}
	setmetatable( obj, self )
	self.__index = self
	return obj
end

-- Initialize Object
function BlockFactory:spawn(  )
	self.blocks = {} -- Hold alive blocks
end

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

-- Reset the block table, removing nil indecies
function BlockFactory:refactor(  )
	local newT = {}

	for i=1,#self.blocks do
		if self.blocks[i] ~= nil then
			table.insert( newT, self.blocks[i] )
		end
	end

	self.blocks = newT
end

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

return BlockFactory
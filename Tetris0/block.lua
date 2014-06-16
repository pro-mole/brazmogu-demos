-- Implementing the blocks
-- Emphasis on copy and removal operations

Block = {
	x = 0,
	y = 0
}

Block.__index = Block

function Block.new(_x, _y)
	return setmetatable({x=_x, y=_y}, Block)
end

function Block:remove()
	for i,B in ipairs(Grid.blocks) do
		if B == self then
			table.remove(Grid.blocks, i)
			break
		end
	end
end
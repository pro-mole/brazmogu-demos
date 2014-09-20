-- Global Settings
-- Later on, load this from somewhere
Settings = {
	grid_width = 9, -- Grid information
	grid_height = 9,
	tile_size = 32, -- Size to scale the tiles 
	match_size = 3, -- Minimum size of matching sets
}

require("grid")
_grid = nil

function love.load()
	repeat
		_grid = Grid.new()

		local line = ""
		for pos,T in _grid:iterate() do
			if pos[1] == 1 then
				print(line)
				line = ""
			end
			line = line..T.value
		end

		local m = _grid:checkMatch()
		local size = 0
		for T,v in pairs(m) do
			size = size + 1
		end
	until size == 0
end

function love.update(dt)
end

function love.mousepressed(m,x,y)
end

function love.draw()
	_grid:draw()
end

function love.quit()
end
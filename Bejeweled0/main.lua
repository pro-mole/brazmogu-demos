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

function love.mousepressed(x,y,button)
	if button == "l" then
		local _x, _y = math.ceil((x - _grid.offx)/Settings.tile_size), math.ceil((y - _grid.offy)/Settings.tile_size)
		local T = _grid:getTile(_x, _y)
		if T then
			if _grid.selected then
				local S = _grid.selected
				if S == T then
					_grid.selected = nil
				elseif (T.x == S.x and math.abs(T.y - S.y) == 1) or (T.y == S.y and math.abs(T.x - S.x)) then
					_grid:swap(S,T)
					_grid.selected = nil
				else
					_grid.selected = T
				end
			else
				_grid.selected = T
			end
		end
	end
end

function love.draw()
	_grid:draw()
end

function love.quit()
end
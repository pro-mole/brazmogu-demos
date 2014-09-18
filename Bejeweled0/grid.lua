-- The Game Grid

-- Tile enumerator
-- 0 means an empty tile
Tile = {
	"FIRE",
	"EARTH",
	"WATER",
	"AIR"
}

Colors = {
	[0] = {0,0,0,255},
	[1] = {128,0,0,255},
	[2] = {96,64,0,255},
	[3] = {0,96,128,255},
	[4] = {192,192,0,255}
}

Grid = {
	w = 1,
	h = 1,
	tiles = nil
}
Grid.__index = Grid

function Grid.new(w,h)
	local G = {
		w = w or Settings.grid_width,
		h = h or Settings.grid_height,
		tiles = {}
	}
	setmetatable(G, Grid)

	for y = 1,G.h do
		G.tiles[y] = {}
		local row = G.tiles[y]
		for x = 1,G.w do
			row[x] = math.random(#Tile)
		end
	end

	print(string.format("Created grid with size %dx%d",G.w,G.h))
	print(G.tiles, #G.tiles)

	return G
end

function Grid:draw()
	local offsetx = (love.window.getWidth() - Settings.tile_size*self.w)/2
	local offsety = (love.window.getHeight() - Settings.tile_size*self.h)/2
	for pos,T in self:iterate() do
		love.graphics.setColor(unpack(Colors[T]))

		love.graphics.rectangle("fill", offsetx + (pos[1]-1)*Settings.tile_size, offsety + (pos[2]-1)*Settings.tile_size, Settings.tile_size, Settings.tile_size)
	end

	love.graphics.setColor(0,0,0,255)
end

function Grid:getTile(x,y)
	if x < 1 or x > self.w or y < 1 or y > self.h then
		return nil
	else
		return self.tiles[y][x]
	end
end

function Grid:setTile(x,y,T)
end

-- Check for matches in the grid
-- Return a table containing the tiles that are matching with anything
function Grid:checkMatch()
end

-- Apply changes to table
-- Used to actually remove the tiles marked for removal by the match function
function Grid:resolve()
end

-- Organize grid, pushing down the empty tiles, if any
function Grid:organize()
end

-- Iterator function for the grid
function Grid:iterate()
	return function(grid, p)
		local x, y = unpack(p)
		x = x + 1
		if x > grid.w then
			x = 1
			y = y + 1
		end
		if y > grid.h then return nil end
		return {x,y}, grid:getTile(x,y)
	end, self, {0, 1}
end
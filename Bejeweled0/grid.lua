-- The Game Grid

-- Tile class 
Tile = {

}
Tile.__index = Tile

function Tile.new(x,y,T)
	if not T or T > #TileTypes or T < 0 then
		T = math.random(#TileTypes)
	end

	return setmetatable({x=x, y=y, value=T}, Tile)
end

TileTypes = {
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
	G.offx = (love.window.getWidth() - Settings.tile_size*G.w)/2
	G.offy = (love.window.getHeight() - Settings.tile_size*G.h)/2
	G.width = Settings.tile_size*G.w
	G.height = Settings.tile_size*G.h
	setmetatable(G, Grid)

	for y = 1,G.h do
		G.tiles[y] = {}
		local row = G.tiles[y]
		for x = 1,G.w do
			row[x] = Tile.new(x,y)
		end
	end

	print(string.format("Created grid with size %dx%d",G.w,G.h))
	print(G.tiles, #G.tiles)

	return G
end

function Grid:update(dt)
end

function Grid:draw()
	local matches = self:checkMatch()

	love.graphics.push()
	love.graphics.translate(self.offx, self.offy)
	for pos,T in self:iterate() do
		local x,y = unpack(pos)
		local offx, offy = T.offx or 0, T.offy or 0
		love.graphics.setColor(unpack(Colors[T.value]))

		love.graphics.rectangle("fill", (x-1)*Settings.tile_size + offx, (y-1)*Settings.tile_size + offy, Settings.tile_size, Settings.tile_size)
		if self.selected and self.selected == T then
			love.graphics.setColor(255,255,255,128)
			
			love.graphics.rectangle("fill", (x-1)*Settings.tile_size + 4 + offx, (y-1)*Settings.tile_size + 4 + offy, Settings.tile_size - 8, Settings.tile_size - 8)
		end
		if matches[T] and T.value ~= 0 then
			love.graphics.setColor(255,255,255,128)

			love.graphics.rectangle("fill", (x-1)*Settings.tile_size + offx, (y-1)*Settings.tile_size + offy, Settings.tile_size, Settings.tile_size)
		end
	end
	love.graphics.pop()

	love.graphics.setColor(0,0,0,255)
end

function Grid:getTile(x,y)
	if x < 1 or x > self.w or y < 1 or y > self.h then
		return nil
	else
		return self.tiles[y][x]
	end
end

function Grid:swap(T1,T2)
	print(T1,T2)
	print(T1.x,T1.y)
	print(T2.x,T2.y)
	self.tiles[T1.y][T1.x] = T2
	self.tiles[T2.y][T2.x] = T1
	T1.x, T1.y, T2.x, T2.y = T2.x, T2.y, T1.x, T1.y
end

-- Check for matches in the grid
-- Return a table containing the tiles that are matching with anything
function Grid:checkMatch()
	local matches = {}
	for pos,T in self:iterate() do
		local x,y = unpack(pos)
		local dx,dy = 0,0
		while self:getTile(x+dx+1,y) and self:getTile(x+dx+1,y).value == T.value do
			dx = dx + 1
		end
		while self:getTile(x,y+dy+1) and self:getTile(x,y+dy+1).value == T.value do
			dy = dy + 1
		end
		if dx >= Settings.match_size - 1 then
			for i=0,dx do
				matches[self:getTile(x+i,y)] = true
			end
		end
		if dy >= Settings.match_size - 1 then
			for i=0,dy do
				matches[self:getTile(x,y+i)] = true
			end
		end
	end

	return matches
	--[[local M = {}
	for i,v in pairs(matches) do
		if v then table.insert(M,i) end
	end

	return M]]
end

-- Apply changes to table
-- Used to actually remove the tiles marked for removal by the match function
function Grid:resolve()
	local change = false
	local matches = self:checkMatch()
	for T in pairs(matches) do
		T.value = 0
		change = true
	end

	return change
end

-- Organize grid, pushing down the empty tiles, if any
function Grid:organize()
	for x = 1,self.w do
		for y = 1,self.h do
			T = self:getTile(x,y)
			if T.value == 0 then
				print(string.format("Empty at %d,%d", x, y))
				for _y = y-1,1,-1 do
					print(string.format("Slide %d down", _y))
					self:swap(T, self:getTile(x,_y))
				end
			end
		end
	end
	
	for pos,T in self:iterate() do
		if T.value == 0 then
			T.value = math.random(#TileTypes)
		end
	end
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
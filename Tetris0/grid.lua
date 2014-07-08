-- Implementing a sparse grid
-- Reasoning: It will probably spend most of the game not completely filled, and also we need to deal with the possibility of elements being *out* of the grid("spill")

Grid = {
	width = 0,
	height = 0,
	tile_size = 0,
	blocks = {}, -- All the blocks in the game
	active = nil, -- Here is our falling block's configuration; so we can rotate it and stuff
	speed = 1, -- Faster and faster as the lines start disappearing >=]
	timer = 0
}

score = 0
endgame = false

-- An easier way to deal with this tedious pattern creation
function tetromino(...)
	print(...)
	assert(#{arg} ~= 8, "Tetromino configuration must have 4 pairs of coordinates")
	
	local T = {}
	
	subblocks = {...}
	for i = 1,8,2 do
		table.insert(T, {x = subblocks[i], y = subblocks[i+1]}) 
	end
	
	return T
end

function turnCW(_x,_y)
	return {x = -_y, y = _x}
end

function turnCCW(_x,_y)
	return {x = _y, y = -_x}
end

Tetras = { -- Tetromino configurations
	tetromino(0,0, 1,0, 1,1, 0,1), -- Square
	tetromino(0,0, 1,1, 0,1, 0,-1),-- L-Right
	tetromino(0,0, -1,1, 0,1, 0,-1),-- L-Left
	tetromino(0,0, -1,0, 0,-1, 1,-1),-- Duck-Right
	tetromino(0,0, 1,0, 0,-1, -1,-1),-- Duck-Left
	tetromino(-1,0, 0,0, 1,0, 2,0),-- Line
	tetromino(0,0, 0,-1, -1,-1, 1,-1)-- T-Shape
}

function Grid.new(w, h, s)
	Grid.width, Grid.height, Grid.tile_size = w or 16, h or 32, s or 8
	Grid.blocks = {}
	Grid.active = {}
	Grid.active = nil
	Grid.speed = 1
	Grid.timer = 0
	
	Grid.x, Grid.y = (love.window.getWidth() - Grid.width * Grid.tile_size)/2, (love.window.getHeight() - Grid.height * Grid.tile_size)/2

	score = 0
	endgame = false
	
	return Grid
end

function Grid:keypressed(k, isrepeat)
	if not self.active then return end
	
	if endgame then
		if k == "r" then
			Grid.new(self.width, self.height, self.tile_size)
		end
	else
		if k == "up" then
			for i,t in ipairs(self.active.blocks) do
				self.active.blocks[i] = turnCW(t.x, t.y)
			end
			if not self:checkActiveBlock() then
				for i,t in ipairs(self.active.blocks) do
					self.active.blocks[i] = turnCCW(t.x, t.y)
				end
			end
		end
		
		if k == "left" then
			self.active.x = self.active.x - 1
			if not self:checkActiveBlock() then
				self.active.x = self.active.x + 1
			end
		elseif k == "right" then
			self.active.x = self.active.x + 1
			if not self:checkActiveBlock() then
				self.active.x = self.active.x - 1
			end
		elseif k == "down" then
			while Grid:checkActiveBlock() do
				self.active.y = self.active.y + 1
			end
			self.active.y = self.active.y - 1
		end
	end
end

function Grid:update(dt)
	if not endgame then
		local interval = 1/self.speed
		self.timer = self.timer + dt
		if self.timer >= interval then
			self.timer = self.timer - interval
			if self.active then
				-- Check if active block can move
				self.active.y = self.active.y + 1
				if not self:checkActiveBlock() then
					self.active.y = self.active.y - 1
					for i,b in ipairs(self.active.blocks) do
						table.insert(self.blocks, Block.new(self.active.x + b.x, self.active.y + b.y))
					end
					self.active = nil
					self:checkLine()
					self.timer = interval
				end
			else
				-- Create new tetromino
				self.active = {x = math.floor(self.width/2), y = 1}
				self.active["blocks"] = Tetras[math.random(#Tetras)]
				if not self:checkActiveBlock() then -- if the block can't move when it is created, then we have a problem
					endgame = true
				end
			end
		end
	end
end

function Grid:getBlock(x,y)
	for i,B in ipairs(self.blocks) do
		if B.x == x and B.y == y then
			return B
		end
	end
	
	return nil
end

function Grid:checkActiveBlock()
	for i,B in ipairs(self.active.blocks) do
		local x,y = self.active.x + B.x, self.active.y + B.y
		if x < 1 or x > self.width or y > self.height then
			return false
		end
		
		if self:getBlock(x,y) then
			return false
		end
	end
	
	return true
end

function Grid:checkLine()
	for i = 1,self.height do
		local line = true
		for j = 1,self.width do
			if not self:getBlock(j,i) then
				line = false
				break
			end
		end
		
		if line then
			for j = #self.blocks,1,-1 do
				local B = self.blocks[j]
				if B.y == i then
					B:remove()
				elseif B.y < i then
					B.y = B.y + 1
				end
			end
			self.speed = self.speed + 0.1
			score = score + 100
		end
	end
end

function Grid:draw()
	love.graphics.push()
	love.graphics.translate(self.x, self.y)
	
	-- Draw the "fixed" blocks
	love.graphics.translate(-self.tile_size, -self.tile_size)
	for i,B in ipairs(self.blocks) do
		love.graphics.setColor(128,128,128,255)
		love.graphics.rectangle("fill", B.x * self.tile_size, B.y * self.tile_size, self.tile_size, self.tile_size)
		love.graphics.setColor(0,0,0,255)
		love.graphics.rectangle("line", B.x * self.tile_size, B.y * self.tile_size, self.tile_size, self.tile_size)
	end
	
	-- Draw the active blocks
	if self.active then
		for i,B in ipairs(self.active.blocks) do
			love.graphics.setColor(255,255,255,255)
			love.graphics.rectangle("fill", (self.active.x + B.x)* self.tile_size, (self.active.y + B.y) * self.tile_size, self.tile_size, self.tile_size)
			love.graphics.setColor(0,0,0,255)
			love.graphics.rectangle("line", (self.active.x + B.x)* self.tile_size, (self.active.y + B.y) * self.tile_size, self.tile_size, self.tile_size)
		end
	end

	love.graphics.pop()

	love.graphics.push()
	love.graphics.translate(self.x, self.y)

	love.graphics.setColor(255,255,255,255)
	love.graphics.line(-1, -1, -1, self.height * self.tile_size + 1)
	love.graphics.line(self.width * self.tile_size + 1, -1, self.width * self.tile_size + 1, self.height * self.tile_size + 1)
	love.graphics.line(-1, self.height * self.tile_size + 1, self.width * self.tile_size + 1, self.height * self.tile_size + 1)

	love.graphics.print(string.format("%08d", score), 0, self.height * self.tile_size + 2)

	if endgame then
		love.graphics.origin()
		love.graphics.setColor(0,0,0,128)
		love.graphics.rectangle("fill", 0, 0, love.window.getWidth(), love.window.getHeight())

		local font = love.graphics.getFont()
		love.graphics.setColor(0,0,0,192)
		love.graphics.rectangle("fill", 0, love.window.getHeight()/2 - font:getHeight(), love.window.getWidth(), font:getHeight() * 2)
		love.graphics.setColor(255,255,255,255)
		love.graphics.printf("GAME OVER\n(Press 'R' to restart)", 0, love.window.getHeight()/2 - font:getHeight(), love.window.getWidth(), "center")
	end

	love.graphics.pop()
end
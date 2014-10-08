--Maze grid

Maze = {
	height=0,
	width=0,
	tile_size = 32,
	wall_thickness = 4
}
Maze.__index = Maze

Cell = {
	OPENINGS = {
		UP=1,
		DOWN=2,
		LEFT=4,
		RIGHT=8
	}
}
Cell.__index = Cell

function Maze.new(w,h,tile_layout)
	local w = w
	local h = h or w
	local layout = tile_layout

	local M = {
		height = h,
		width = w,
		cells = {}
	}

	for y=1,h do
		table.insert(M.cells, {})
		for x=1,w do
			if tile_layout then
				table.insert(M.cells[y], Cell.new("", tile_layout[y][x]))
			else
				table.insert(M.cells[y], Cell.new("", 0))
			end
		end
	end

	return setmetatable(M, Maze)
end

-- Define a cell of the maze using binary operations for the 
function Cell.new(contents, openbits)
	local cell = {
		contents = contents or "",
		openings = {
			up = openbits % 2 == 1,
			down = openbits % 4 - openbits % 2 == 2,
			left = openbits % 8 - openbits % 4 == 4,
			right = openbits % 16 - openbits % 8 == 8
		}
	}

	return setmetatable(cell, Cell)
end

function Maze:draw()
	love.graphics.push()
	love.graphics.translate((love.window.getWidth() - self.width*self.tile_size)/2, (love.window.getHeight() - self.height*self.tile_size)/2)

	for y=1,self.height do
		for x=1,self.width do
			love.graphics.setColor(0,0,128,255)
			self.cells[y][x]:draw()
			love.graphics.translate(self.tile_size, 0)
		end
		love.graphics.translate(-self.width*self.tile_size, self.tile_size)
	end

	love.graphics.pop()
	love.graphics.setColor(255,255,255,255)
end

function Cell:openingValue()
	local v = 0
	if self.openings.up then v = v + 1 end
	if self.openings.down then v = v + 2 end
	if self.openings.left then v = v + 4 end
	if self.openings.right then v = v + 8 end
end

function Cell:isOpen(direction)
	return self.openings[direction]
end

function Cell:draw()
	love.graphics.rectangle("line",Maze.wall_thickness, Maze.wall_thickness, Maze.tile_size-Maze.wall_thickness*2, Maze.tile_size-Maze.wall_thickness*2)
end
require("maze")
require("mazeobject")

_maze = nil

function love.load()
	_maze = Maze.new(9,9,
		{"AEEEFEEE6",
		 "BFF73BFF7",
		 "BFF73BFF7",
		 "BDD539DD7",
		 "FCCCFCCCF",
		 "BEE63AEE7",
		 "BFF73BFF7",
		 "BFF73BFF7",
		 "9DDDFDDD5"})
end

function love.keypressed(key, isrepeat)
	if key == "escape" then
		love.event.quit()
	end
end

function love.update(dt)
	_maze:update(dt)
end

function love.draw()
	_maze:draw()
end

function love.quit()
end
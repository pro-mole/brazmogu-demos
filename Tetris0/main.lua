require("grid")
require("block")

function love.load()
	Grid.new(10, 20, 16)
end

function love.update(dt)
	Grid:update(dt)
end

function love.keypressed(k, isrepeat)
	Grid:keypressed(k, false)
end

function love.draw()
	Grid:draw()
end
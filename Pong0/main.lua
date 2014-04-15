require("paddle")
require("ball")

sound = {}

paddles = {}
ball = {}

function love.load()
	paddles.P1 = Paddle.new(64, love.window.getHeight()/2, "P1")
	paddles.P2 = Paddle.new(love.window.getWidth()-64, love.window.getHeight()/2, "P2")

	ball = Ball.new()
end

function love.keypressed(key, isrepeat)
end

function love.update(dt)
end

function love.draw()
	-- Draw court

	-- Draw paddles
	for i,P in pairs(paddles) do
		P:draw()
	end

	-- Draw ball
	ball:draw()
end

function love.quit()
end
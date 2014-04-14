require("paddle")
require("brick")
require("ball")

print(elements)

sound = {}

function love.load()
	-- Load data
	sound = {bump=love.audio.newSource("assets/sound/bump_hollow.wav","static") , tick=love.audio.newSource("assets/sound/bump_tinkle.wav","static")}

	score = 0
	endgame = false
	
	Paddle.x = (love.window.getWidth() - Paddle.size)/2
	Paddle.y = 400

	Ball.x = Paddle.x + (Paddle.size/2) - 4
	Ball.y = Paddle.y - 64 - 8
	Ball.vdir = -1
	Ball.hdir = 1

	Bricks.bricks = {}
	for y = 0, 120, 24 do
		for x = 0, love.window.getWidth(), 32 do
			Bricks:newBrick(x, y)
		end
	end
end

function love.update(dt)
	if not endgame then
		Paddle:update(dt)
		Ball:update(dt)
		Bricks:update(dt)
	end
end

function love.draw()
	-- love.graphics.print("Loading Breakout Gameplay Demo...",4,4)
	Paddle:draw()
	Ball:draw()
	Bricks:draw()

	love.graphics.print("SCORE: " .. score, 4, love.window.getHeight() - 20)

	if endgame then
		love.graphics.printf("GAME OVER", love.window.getWidth()/2 - 100, love.window.getHeight()/2, 200, "center")
		love.graphics.printf("(PRESS 'R' TO TRY AGAIN)", love.window.getWidth()/2 - 200, love.window.getHeight()/2 + 16, 400, "center")
	end

	if love.keyboard.isDown("r") and endgame then
		endgame = false
		love.load()
	end
end

function love.quit()
	-- Save and Clean up
end

function addScore(points)
	score = score + points
end
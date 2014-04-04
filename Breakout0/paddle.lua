-- Let's define the Paddle object here

Paddle = { size = 100, speed = 150, x = 0, y = 0 }

function Paddle:draw()
	love.graphics.rectangle("fill", self.x, self.y, self.size, 8)
end

function Paddle:update(dt)
	-- Move around
	if love.keyboard.isDown("right") then
		Paddle.x = Paddle.x + 100*dt
	end
	if love.keyboard.isDown("left") then
		Paddle.x = Paddle.x - 100*dt
	end

	-- Don't get off the edges!
	if Paddle.x < 0 then
		Paddle.x = 0
	end
	if Paddle.x > (love.window.getWidth() - Paddle.size) then
		Paddle.x = love.window.getWidth() - Paddle.size
	end
end
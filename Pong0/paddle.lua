-- Pong Paddles

Paddle={speed=100, size=50, thick=4}
Paddle.__index = Paddle

function Paddle.new (x,y,player)
	_P = {x=x, y=y or love.window.getHeight()/2, player=player}

	return setmetatable(_P, Paddle)
end

function Paddle:update(dt)
	if love.keyboard.isdown(settings.controls[self.player]['up']) then
		if self.y > self.size/2 then
			self.y = self.y - 100*dt
		end
	end
	
	if love.keyboard.isdown(settings.controls[self.player]['down']) then
		if self.y < (love.window.getHeight() - self.size/2) then
			self.y = self.y + 100*dt
		end
	end
end

function Paddle:draw()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.rectangle("fill", self.x - self.thick/2, self.y - self.size/2, self.thick, self.size)
end

function Paddle:keypressed(key,isrepeat)
	-- Ball is ready to be thrown
	if isrepeat then return end
	
	if ball.speed == 0 and ball.player == self.player then
		if key == settings.controls[self.player]['up'] then
			ball.speed = 100
			if ball.x < self.x then -- Ball to the left
				ball.direction = 135
			else
				ball.direction = 45
			end
		else if key == settings.controls[self.player]['down'] then
			ball.speed = 100
			if ball.x < self.x then -- Ball to the left
				ball.direction = 225
			else
				ball.direction = 315
			end
		end
	end
end

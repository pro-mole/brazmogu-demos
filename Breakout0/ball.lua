-- Let's define the Ball object here

Ball = { speed = 100, size = 4, x = 0, y = 0, hdir = 1, vdir = -1}

function Ball:draw()
	love.graphics.circle("fill", self.x+self.size, self.y+self.size, self.size, 4)
end

function Ball:update(dt)
	-- Check collision and bounce around
	self.x = self.x + self.hdir*dt*self.speed
	self.y = self.y + self.vdir*dt*self.speed

	-- Bounce
	if self.y <= 0 then
		self.vdir = -self.vdir
		self.y = 0
	end

	-- Paddle Bounce
	if self.y >= (Paddle.y - self.size*2) and self.y <= Paddle.y and (self.x >= Paddle.x and self.x <= Paddle.x + Paddle.size - self.size) then
		self.vdir = -self.vdir
		-- Horizontal speed variance
		local delta = (self.x + self.size) - (Paddle.x + Paddle.size/2)
		self.hdir = self.hdir + (delta / Paddle.size)
		self.y = Paddle.y - self.size*2
	end

	if self.x <= 0 or self.x >= (love.window.getWidth() - self.size*2) then
		self.hdir = -self.hdir
		if self.x < 0 then self.x = 0 end
		if self.x > (love.window.getWidth() - self.size*2) then self.x = (love.window.getWidth() - self.size*2) end
	end

	-- Lose
	if self.y >= love.window.getHeight() then
		endgame = true
	end

end
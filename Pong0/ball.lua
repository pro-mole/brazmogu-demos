-- Pong Ball

Ball = {size=3}
Ball.__index = Ball

function Ball.new(x, y, player)
	_B = {x=x or love.window.getWidth()/2, y=y or love.window.getHeight()/2, speed=0, direction=0, player=player or "P1"}

	return setmetatable(_B, Ball)
end

function Ball:update(dt)
	-- Ball is waiting to be shot
	local vx, vy = math.cos(math.rad(self.direction)), -math.sin(math.rad(self.direction))

	if speed == 0 then
		self.y = paddles[self.player].y
	else
		self.x = self.x + self.speed*vx*dt
		self.y = self.y + self.speed*vy*dt
	end

	-- Bounce off the walls
	if self.y <= self.size and vy < 0 then
		sound.hollow:play()
		self.direction = 360 - self.direction 
	elseif self.y >= love.window.getHeight() - self.size and vy > 0 then
		sound.hollow:play()
		self.direction = 360 - self.direction
	end

	if self.x <= self.size and vx < 0 then
		score.P2 = score.P2 + 1
		ball = Ball.new(love.window.getWidth()*0.75, love.window.getHeight()/2, "P2")
	elseif self.x >= love.window.getWidth() - self.size and vx > 0 then
		score.P1 = score.P1 + 1
		ball = Ball.new(love.window.getWidth()*0.25, love.window.getHeight()/2, "P1")
	end

	-- Bounce off the paddles
	for i,P in pairs(paddles) do
		if vx > 0 and self.x >= P.x - P.thick/2 - self.size  and self.x <= P.x - P.thick/2 and
		self.y >= P.y - P.size/2 - self.size and self.y <= P.y + P.size/2 + self.size then
			sound.tinkle:play()
			self.direction = 180 - self.direction + (self.y - P.y)/(P.size/2)*30
		elseif vx < 0 and self.x <= P.x + P.thick/2 + self.size and self.x >= P.x + P.thick/2 and
		self.y >= P.y - P.size/2 - self.size and self.y <= P.y + P.size/2 + self.size then
			sound.tinkle:play()
			self.direction = 180 - self.direction + (self.y - P.y)/(P.size/2)*30
		end
	end
end

function Ball:draw()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.circle("fill", self.x, self.y, self.size, 8)

	--[[love.graphics.setFont(love.graphics.newFont(8))
	love.graphics.setColor(0,0,0,255)
	love.graphics.print(self.player, self.x-self.size, self.y-self.size/2)']]
end

function Ball:keypressed(key,isrepeat)
end
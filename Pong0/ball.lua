-- Pong Ball

Ball = {size=2}
Ball.__index = Ball

function Ball.new(x, y)
	_B = {x=x or love.window.getWidth()/2, y=y or love.window.getHeight()/2, speed=0, direction=nil, player="P1"}

	return setmetatable(_B, Ball)
end

function Ball:update(dt)
end

function Ball:draw()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.circle("fill", self.x, self.y, self.size, 16)
end

function Ball:keypressed(key,isrepeat)
end
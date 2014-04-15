-- Pong Paddles

Paddle={speed=100, size=50, thick=4}
Paddle.__index = Paddle

function Paddle.new (x,y,player)
	_P = {x=x, y=y or love.window.getHeight()/2, player=player}

	return setmetatable(_P, Paddle)
end

function Paddle:update(dt)
end

function Paddle:draw()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.rectangle("fill", self.x - self.thick/2, self.y - self.size/2, self.thick, self.size)
end

function Paddle:keypressed(key,isrepeat)
end

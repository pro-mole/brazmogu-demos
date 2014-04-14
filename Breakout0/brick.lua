-- Let's define the bricks here

Bricks = { bricks={} }

function Bricks:newBrick(x, y, color)
	table.insert(self.bricks, { x = x or 0, y = y or 0, width = 32, height = 24, color = color or {0xff,0xff,0xff} })
end

function Bricks:draw()
	for i,B in ipairs(self.bricks) do
		love.graphics.rectangle("fill", B.x+1, B.y+1, B.width - 2, B.height - 2)
	end
end

function Bricks:removeBrick(i, points)
	table.remove(self.bricks, i)
	addScore(points)
end

function Bricks:update()
	for i,B in ipairs(self.bricks) do
		local collision = {v = false, h = false}
		-- Collision from below
		if Ball.vdir < 0 and (Ball.x >= B.x - Ball.size*2) and (Ball.x <= B.x + B.width) and
			(Ball.y >= B.y + B.height - Ball.size*2) and (Ball.y <= B.y + B.height) then
			collision.v = true
		end
		-- Collision from above
		if Ball.vdir > 0 and (Ball.x >= B.x - Ball.size*2) and (Ball.x <= B.x + B.width) and
			(Ball.y >= B.y - Ball.size*2) and (Ball.y <= B.y) then
			collision.v = true
		end
		-- Collision from the left
		if Ball.hdir > 0 and (Ball.x >= B.x - Ball.size*2) and (Ball.x <= B.x) and
			(Ball.y >= B.y - Ball.size*2) and (Ball.y <= B.y + B.height) then
			collision.h = true
		end
		-- Collision from the right
		if Ball.hdir < 0 and (Ball.x >= B.x + B.width - Ball.size*2) and (Ball.x <= B.x + B.width) and
			(Ball.y >= B.y - Ball.size*2) and (Ball.y <= B.y + B.height) then
			collision.h = true
		end

		if collision.h or collision.v then
			love.audio.play(sound.tick)
			self:removeBrick(i, 100)
			if collision.v then Ball.vdir = -Ball.vdir end
			if collision.h then Ball.hdir = -Ball.hdir end
		end
	end
end
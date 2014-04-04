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
		local collision = false
		-- Collision from below
		if (Ball.x >= B.x - Ball.size*2) and (Ball.x <= B.x + B.width) and
			(Ball.y >= B.y + B.height - Ball.size*2) and (Ball.y <= B.y + B.height) then
			Ball.vdir = -Ball.vdir
			collision = true
		end
		-- Collision from above
		if (Ball.x >= B.x - Ball.size*2) and (Ball.x <= B.x + B.width) and
			(Ball.y >= B.y - Ball.size*2) and (Ball.y <= B.y) then
			Ball.vdir = -Ball.vdir
			collision = true
		end
		-- Collision from the left
		if (Ball.x >= B.x - Ball.size*2) and (Ball.x <= B.x) and
			(Ball.y >= B.y - Ball.size*2) and (Ball.y <= B.y + B.height) then
			Ball.hdir = -Ball.hdir
			collision = true
		end
		-- Collision from the right
		if (Ball.x >= B.x + B.width - Ball.size*2) and (Ball.x <= B.x + B.width) and
			(Ball.y >= B.y - Ball.size*2) and (Ball.y <= B.y + B.height) then
			Ball.hdir = -Ball.hdir
			collision = true
		end

		if collision then
			self:removeBrick(i, 100)
		end
	end
end
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
		if (Ball.x >= B.x - Ball.size) and (Ball.x <= B.x + B.height) and (Ball.y >= B.y - Ball.size) and (Ball.y <= B.y + B.height) then
			if Ball.vdir > 0 and Ball.y <= B.y then
				Ball.vdir = -Ball.vdir
				self:removeBrick(i, 100)
				break
			elseif Ball.vdir < 0 and Ball.y >= B.y + B.height - Ball.size then
				Ball.vdir = -Ball.vdir
				self:removeBrick(i, 100)
				break
			elseif Ball.hdir > 0 and Ball.x <= B.x then
				Ball.hdir = -Ball.hdir
				self:removeBrick(i, 100)
				break
			elseif Ball.hdir > 0 and Ball.x >= B.x + B.width - Ball.size then
				Ball.hdir = -Ball.hdir
				self:removeBrick(i, 100)
				break
			end
		end
	end
end
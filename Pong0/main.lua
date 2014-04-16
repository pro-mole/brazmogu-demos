require("paddle")
require("ball")

sound = {}

paddles = {}
ball = {}
settings = {controls = {
	P1 = {
		up='w',
		down='s'
		},
	P2 = {
		up='up',
		down='down'
		}
	}}

function love.load()
	paddles.P1 = Paddle.new(64, love.window.getHeight()/2, "P1")
	paddles.P2 = Paddle.new(love.window.getWidth()-64, love.window.getHeight()/2, "P2")
	-- settings:load()

	ball = Ball.new()
end

function love.keypressed(key, isrepeat)
end

function love.update(dt)
	for i,P in paddles do P:update(dt) end
	ball:update(dt)
end

function love.draw()
	-- Draw court

	-- Draw paddles
	for i,P in pairs(paddles) do
		P:draw()
	end

	-- Draw ball
	ball:draw()
end

function love.quit()
	settings:save()
end

function settings:save()
	local gamedata = ""
	
	for i,P in pairs(self.controls)
		gamedata = gamedata .. "controls." .. P .. ".up=" .. P.up
		gamedata = gamedata .. "controls." .. P .. ".down=" .. P.down
	end
	
	if not love.filesystem.write("pong.settings", gamedata) then
		print("ERROR: Cannot save settings")
	end
end

function settings:load()
	if not love.filesystem.exists("ppdz.settings") then
		self:save()
	else
		local str, bytes = love.filesystem.read("ppdz.settings")
		print(string.format("%s bytes read from save file", bytes))
		if bytes == 0 then return end
		
		for k, v in string.gmatch(str, "(%w+)=(%w+)") do
			if string.gmatch(k, "controls") then
				for P,K params = string.gmatch(k, "controls.(%w+).(%w+)")
					settings['controls'][P][K] = v
				end
			end
		end
	end
end

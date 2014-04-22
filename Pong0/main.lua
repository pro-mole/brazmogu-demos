require("paddle")
require("ball")

sound = {}
font = {}

score = {}
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
	score.P1 = 0
	score.P2 = 0
	paddles.P1 = Paddle.new(64, love.window.getHeight()/2, "P1")
	paddles.P2 = Paddle.new(love.window.getWidth()-64, love.window.getHeight()/2, "P2")
	-- settings:load()

	sound['hollow'] = love.audio.newSource("assets/sound/bump_hollow.wav")
	sound['tinkle'] = love.audio.newSource("assets/sound/bump_tinkle.wav")

	font['huge'] = love.graphics.newFont("assets/font/imagine_font.otf",24)
	font['big'] = love.graphics.newFont("assets/font/imagine_font.otf",14)
	font['small'] = love.graphics.newFont("assets/font/imagine_font.otf",10)

	ball = Ball.new(love.window.getWidth()*0.25, love.window.getHeight()/2, "P1")
	--ball.speed = 50
	--ball.direction = 135
end

function love.keypressed(key, isrepeat)
	for i,P in pairs(paddles) do
		P:keypressed(key,isrepeat)
	end
end

function love.update(dt)
	for i,P in pairs(paddles) do P:update(dt) end
	ball:update(dt)
end

function love.draw()
	-- Draw court
	love.graphics.setColor(255,255,255,128)
	local piece = love.window.getHeight()/10
	local center_x = love.window.getWidth()/2
	local center_y = love.window.getHeight()/2

	for i=0,4 do
		love.graphics.rectangle("fill", center_x - 2, piece/2 + i*2*piece, 4, piece)
	end

	local score_w = font.huge:getWidth("00")
	love.graphics.setFont(font.big)
	love.graphics.printf("P1", 8, center_y - font.huge:getHeight()/2 - font.big:getHeight() - 4, score_w, "center")
	love.graphics.printf("P2", love.window.getWidth() - score_w - 8, center_y - font.huge:getHeight()/2 - font.big:getHeight() - 4, score_w, "center")
	love.graphics.setFont(font.huge)
	love.graphics.printf(score.P1, 8, center_y - font.huge:getHeight()/2, score_w, "center")
	love.graphics.printf(score.P2, love.window.getWidth() - score_w - 8, center_y - font.huge:getHeight()/2, score_w, "center")

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
	
	for i,P in pairs(self.controls) do
		gamedata = gamedata .. "controls." .. i .. ".up=" .. P.up
		gamedata = gamedata .. "controls." .. i .. ".down=" .. P.down
	end
	
	if not love.filesystem.write("pong.settings", gamedata) then
		print("ERROR: Cannot save settings")
	end
end

function settings:load()
	if not love.filesystem.exists("pong.settings") then
		self:save()
	else
		local str, bytes = love.filesystem.read("pong.settings")
		print(string.format("%s bytes read from save file", bytes))
		if bytes == 0 then return end
		
		for k, v in string.gmatch(str, "(%w+)=(%w+)") do
			if string.gmatch(k, "controls") then
				for P,K in string.gmatch(k, "controls.(%w+).(%w+)") do
					settings['controls'][P][K] = v
				end
			end
		end
	end
end

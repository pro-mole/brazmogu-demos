-- Global Settings
-- Later on, load this from somewhere
Settings = {
	grid_width = 9, -- Grid information
	grid_height = 9,
	tile_size = 32, -- Size to scale the tiles 
	match_size = 3, -- Minimum size of matching sets
	UIFx_speed = 0.25 -- Speed factor of UI Effects
}

-- Effects event queue
FxQueue = {}

-- Game state machine
-- Mostly for UI niceties and input control
StateMachine = {
	state = "IDLE",
	fx = nil
}

function StateMachine:update(dt)
	if self.state == "BUSY" then
		-- Do your stuff
		if not fx then
			self:transition("NEXT")
		else
			for e in ipairs(fx) do
				if fx[1] == "swap" then
					local _swap,T1,T2 = unpack(fx)
					local axis = ""
					if T1.x == T2.x then axis = "y"
									else axis = "x" end
					if T1[axis] > T2[axis] then
					end
				end
			end
		end
	end
end

-- State Machine Transition function
-- The meat of this stuff :V
function StateMachine:transition(signal)
	-- Start processing the event list
	if signal == "START" then
		if self.state == "IDLE" then
			if #FxQueue > 0 then
				fx = FxQueue[1]
				table.remove(FXQueue, 1)
				self.state = "BUSY"
			end
		end
	-- Continue through event list or free the game to be played again
	elseif signal == "NEXT" then
		if self.state == "BUSY" then
			if #FxQueue > 0 then
				fx = FxQueue[1]
				table.remove(FxQueue, 1)
			else
				self.state = "IDLE"
			end
		end
	-- Timer countdown signal
	elseif signal == "TIMER" then
	end
end

require("grid")
_grid = nil

function love.load()
	repeat
		_grid = Grid.new()

		local line = ""
		for pos,T in _grid:iterate() do
			if pos[1] == 1 then
				print(line)
				line = ""
			end
			line = line..T.value
		end

		local m = _grid:checkMatch()
		local size = 0
		for T,v in pairs(m) do
			size = size + 1
		end
	until size == 0
end

function love.update(dt)
	StateMachine:update(dt)
	_grid:update(dt)
end

function love.mousepressed(x,y,button)
	if button == "l" and StateMachine.state == "IDLE" then
		local _x, _y = math.ceil((x - _grid.offx)/Settings.tile_size), math.ceil((y - _grid.offy)/Settings.tile_size)
		local T = _grid:getTile(_x, _y)
		if T then
			if _grid.selected then
				local S = _grid.selected
				if S == T then
					_grid.selected = nil
				elseif (T.x == S.x and math.abs(T.y - S.y) == 1) or (T.y == S.y and math.abs(T.x - S.x)) then
					FXQueue[] = {"swap", S, T}
					StateMachine:transition("START")
					_grid.selected = nil
				else
					_grid.selected = T
				end
			else
				_grid.selected = T
			end
		end
	end
end

function love.draw()
	_grid:draw()
end

function love.quit()
end
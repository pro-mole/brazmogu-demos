-- Game State Machine and UI Effects controller

-- Effects event queue
FxQueue = {}

-- Game state machine
-- Mostly for UI niceties and input control
StateMachine = {
	state = "IDLE",
	fx = nil
}

function StateMachine:update(dt)
	local speed = 1.0/Settings.UIFx_speed
	if self.state == "BUSY" then
		-- Do your stuff
		if not self.fx then
			self:transition("NEXT")
		else
			for e in ipairs(self.fx) do
				if e[1] == "swap" then
					local _swap,T1,T2 = unpack(e)
					local axis, off = "", ""
					if T1.x == T2.x then
						axis = "y"
						off = "offy"
					else
						axis = "x"
						off = "offx"
					end
					offset = math.abs(T1[off] or 0)
					offset = offset + dt*speed
					if offset < 1 then
						if T1[axis] > T2[axis] then
							T1[off] = -offset
							T2[off] = offset
						else
							T1[off] = offset
							T2[off] = -offset
						end
					else
						_grid.swap(T1,T2)
						e[1] = "done";
					end
				end
			end
			
			for i = #self.fx,1,-1 do
				if self.fx[i][1] == "done" then table.remove(self.fx,i) end
			end
			
			if #self.fx == 0 then
				self.fx = nil
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
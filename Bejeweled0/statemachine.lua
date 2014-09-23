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
			for i,e in ipairs(self.fx) do
				print(unpack(e))
				if e[1] == "swap" then
					local _swap,T1,T2,noswapback,timer = unpack(e)
					noswapback = noswapback or false
					timer = timer or 0
					local axis, off = "", ""
					if T1.x == T2.x then
						axis = "y"
						off = "offy"
					else
						axis = "x"
						off = "offx"
					end
					offset = math.abs(T1[off] or 0)
					if speed > 0 then offset = offset + dt/speed else offset = 1 end
					timer = timer + dt
					if timer < speed then
						if T1[axis] > T2[axis] then
							T1[off] = -offset
							T2[off] = offset
						else
							T1[off] = offset
							T2[off] = -offset
						end
						e[4] = noswapback
						e[5] = timer
					else
						_grid:swap(T1,T2)
						local swapback = not _grid:resolve()
						print(swapback)
						if swapback and not noswapback then
							table.insert(FxQueue, {{"swap",T1,T2,true}})
						end
						T1[off] = nil
						T2[off] = nil
						e[1] = "done";
					end
				elseif e[1] == "slide" then
					local _slide,Tlist,timer = unpack(e)
					timer = timer or 0
					offset = Tlist[1].offy or 0
					timer = timer + dt
					if timer < speed then
						for i,T in ipairs(Tlist) do
							T.offy = offset + dt/speed
						end
						e[3] = timer
					else
						-- Assuming tiles in the list will be in order from lower to higher
						for i,T in ipairs(Tlist) do
							_grid:swap(T, grid:getTile(T.x, T.y+1))
							T.offy = nil
						end
						e[1] = "done"
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
	print("STATE MACHINE PRE-"..signal.." >> "..self.state)
	
	-- Start processing the event list
	if signal == "START" then
		if self.state == "IDLE" then
			if #FxQueue > 0 then
				self.fx = FxQueue[1]
				table.remove(FxQueue, 1)
				self.state = "BUSY"
			end
		end
	-- Continue through event list or free the game to be played again
	elseif signal == "NEXT" then
		if self.state == "BUSY" then
			if #FxQueue > 0 then
				self.fx = FxQueue[1]
				table.remove(FxQueue, 1)
			else
				self.state = "IDLE"
			end
		end
	-- Timer countdown signal
	elseif signal == "TIMER" then
	end
	
	print("STATE MACHINE POST-"..signal.." >> "..self.state)
end
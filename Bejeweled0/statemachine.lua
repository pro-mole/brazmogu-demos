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
				local f = e[1]
				e[1] = dt
				if FXEvents[f] then
					self.fx[i] = FXEvents[f](unpack(e))
				else
					self.fx[i] = nil
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
				if not _grid:resolve() then
					self.state = "IDLE"
				end
			end
		end
	-- Timer countdown signal
	elseif signal == "TIMER" then
	end
	
	print("STATE MACHINE POST-"..signal.." >> "..self.state)
end

-- FX Event callback functions
FXEvents = {}
function FXEvents.swap(dt,T1,T2,noswapback,timer)
	local noswapback = noswapback or false
	local timer = timer or 0
	local speed = 1.0/Settings.UIFx_speed
	local axis, off = "", ""
	if T1.x == T2.x then
		axis = "y"
		off = "offy"
	else
		axis = "x"
		off = "offx"
	end
	local offset = math.abs(T1[off] or 0)
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
		return {"swap",T1,T2,noswapback,timer}
	else
		_grid:swap(T1,T2)
		local swapback = not _grid:resolve()
		print(swapback)
		if swapback and not noswapback then
			table.insert(FxQueue, {{"swap",T1,T2,true}})
		end
		T1[off] = nil
		T2[off] = nil
		return nil
	end
end

function FXEvents.fall(dt,Tlist,timer)
	local timer = timer or 0
	local speed = 1.0/Settings.UIFx_speed
	local offset = Tlist[1].offy or 0
	timer = timer + dt
	if timer < speed then
		for i,T in ipairs(Tlist) do
			T.offy = offset + dt/speed
		end
		return {"fall",Tlist,timer}
	else
		-- Assuming tiles in the list will be in order from lower to higher
		local last = nil
		for i,T in ipairs(Tlist) do
			_grid:swap(T, _grid:getTile(T.x, T.y+1))
			T.offy = nil
		end
		return nil
	end
end

function FXEvents.shrink(dt,T)
	local scale = T.scale or 1
	local speed = 1.0/Settings.UIFx_speed
	if speed > 0 then scale = scale - dt/speed else scale = 0 end
	if scale > 0 then
		T.scale = scale
		return {"shrink",T}
	else
		T.value = 0
		T.scale = nil
		return nil
	end
end

function FXEvents.spawn(dt,T,val)
	T.value = val
	local speed = 1.0/Settings.UIFx_speed
	local scale = T.scale or 0
	if speed > 0 then scale = scale + dt/speed else scale = 1 end
	if scale < 1 then
		T.scale = scale
		return {"spawn",T,val}
	else
		T.scale = nil
		return nil
	end
end
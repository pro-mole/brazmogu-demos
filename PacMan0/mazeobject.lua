-- Basic maze objecs

Maze.objects = {}

MazeObject = {
	position = {1,1}, -- position on the maze(in tiles, not actual pixels)
	direction = "down", -- facing direction, for sprite drawing purposes
	state = "idle", -- Object state machine
	player = false, -- Player-controlled?
	debug_color = {255,0,0,255}
}
-- Inheritance Function
MazeObject.__index = function(t,index)
	if rawget(t,index) then -- Always look on self first, of course
		return rawget(t,index)
	elseif t['heritage'] then -- Integrate heritage on the subclass "new" functions
		for i,T in ipairs(t.heritage) do
			if rawget(T,index) then
				return rawget(T,index)
			end
		end
	end
		
	return rawget(MazeObject,index) -- Last parent: MazeObject
end

function Maze.newObject(x, y, Type, ...)
	local pos = {x or 0, y or 0}
	
	local object = nil
	if Type then
		object = Type.new(x, y, ...)
	else
		object = setmetatable({position = {x or 0, y or 0}}, MazeObject)
	end
	
	table.insert(Maze.objects, object)
	return object
end

-- Add Object subtypes here
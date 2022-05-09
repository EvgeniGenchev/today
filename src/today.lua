--- Lua script that manages your daily to-do list
-- @author Evgeni Genchev

HOME = os.getenv("HOME")
USER = os.getenv("USER")
DATE = os.date("%d/%m/%y")
DAY = tonumber(DATE:sub(1,2))

--TODO:
-- print banner stating today
-- config file:
------ custom formats on the time display and message display
------ custom banner
--- Add more fields to an event
--- AM/ PM time support: Idea(detect AM or PM; add 12 hours if PM)

--- Split a string at a specified character and turns it into table
-- @param str The string that will be split
-- @param chr The char that the string will be separeated at
-- @return list Table made up from the separated strings
local function split(str, chr)

	assert(#chr == 1)
	local list = {}
	local temp = ""
	local c
	local count = 1

	for i = 1, #str do
		c = str:sub(i,i)
		if c ~= chr then
			temp = temp .. c
		else
			list[count] = temp
			temp = ""
			count = count + 1
		end
	end
	list[count] = temp

	return list
end

local function banner ()

	local frame = ""

	banner = "\tHi, " .. USER .. " 👋\n\tYour tasks for today 🗓️ "

	repeat
		frame = frame .. "-"
	until #frame == #banner

	print(banner)

end


--TODO: Include config file customization of time and msg

--- Prints an event in a readeable format
-- @param time The event time
-- @param msg The event message
-- @param priority The priority of the event (LOW, MEDIUM, HIGH)
local function print_event(time, msg, priority)
	local task
	if priority == "HIGH" then
		task = "\n\t" .. "\27[31m" ..msg .. "\27[0m".. "\n\tTime: " .. time
	end

	if priority == "MEDIUM" then
		task = "\n\t" .."\27[33m" .. msg .. "\27[0m".. "\n\tTime: " .. time
	end

	if priority == "LOW" then
		task = "\n\t" .."\27[36m" .. msg .. "\27[0m" .. "\n\tTime: " .. time
	end

	print(task)
end


--- This function deletes old events
-- @param sched_path The path of the .cache file
-- @param count The number of lines to remove from the begining
local function del_function(sched_path, count)

	local file = assert(io.open(sched_path, "r"))
	local lines = {}
	local c = 1

	for line in file:lines() do
		if c > count then
			lines[c - count] = line
		end
		c = c + 1
	end
	file:close()
	file = io.open(sched_path, "w+")

	for i = 1, #lines do
		file:write(string.format("%s\n", lines[i]))
	end
	file:close()

end

-- This function turns string time into secounds
-- @param s String value of time in format (hour:minute)
-- @return secounds value of s
local function stime(s)
	local pattern = "(%d+):(%d+)"
	local hours, minutes = s:match(pattern)
	return (hours*3600) + (minutes*60)
end

--- Insertion sort based on event's time
-- @param list The list of events to be sorted
-- @return list Sorted by time array
local function sort_day(list)
	local len = #list

	for j = 2, len do
		local key = list[j]
		local i = j - 1
		while i > 0 and stime(list[i][2]) > stime(key[2]) do
			list[i + 1] = list[i]
			i = i - 1
		end
		list[i + 1] = key
	end

	return list
end


--- This function reads the .cache file, deletes the expired events and prints
--- the sorted by time events for today
local function get_today()

	local sched_path = HOME .. "/.cache/today/schedule.csv"
	local f = assert(io.open(sched_path, "r"))
	local line, tb
	local lines = {}
	local del_count = 0

	while true do
		line = f:read("*line")
		if line == nil then break end
		tb = split(line, ',')
		local t = tonumber(tb[1]:sub(1,2))

		if t < DAY then del_count = del_count + 1 end
		if t == DAY then table.insert(lines, tb) end
		if t > DAY then break end

	end

	lines = sort_day(lines)

	for i=1, #lines do
		local l = lines[i]
		print_event(l[2], l[3], l[4])
	end


	f:close()
	if del_count ~= 0 then
		del_function(sched_path, del_count)
	end
end

banner()
get_today()

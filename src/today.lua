HOME = os.getenv("HOME")
DATE = os.date("%x")

--TODO:
-- Delete all previous caches 
-- remove "Task:" from output
-- print banner stating today
-- config file:
------ custom formats on the time display and message display
------ custom banner

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

local function print_event(time, msg, priority)
	local task
	if priority == "HIGH" then
		task = "Task:\n\t" .. "\27[31m" ..msg .. "\27[0m".. "\n\tTime: " .. time .. "\n"
	end

	if priority == "MEDIUM" then
		task = "Task:\n\t" .."\27[33m" .. msg .. "\27[0m".. "\n\tTime: " .. time .. "\n"
	end

	if priority == "LOW" then
		task = "Task:\n\t" .."\27[36m" .. msg .. "\27[0m" .. "\n\tTime: " .. time .. "\n"
	end

	print(task)
end


local function get_today()

	local sched_path = HOME .. "/.cache/today/schedule.csv"
	local f = assert(io.open(sched_path, "r"))
	local line, tb

	while true do
		line = f:read("*line")
		if line == nil then break end
		tb = split(line, ',')
		print_event(tb[2], tb[3], tb[4])
	end

	f:close()
end

get_today()

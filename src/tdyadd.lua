--- TODO:
--read args
------ 1st date
------ 2nd time
------ 3rd msg
------ 4th priority
-- insert into .cache/today/schedule.csv
------ insertion sort to get place into the right position based on date and time
------ delete everything outdated

HOME = os.getenv("HOME")
DATE = os.date("%d/%m/%y")

if #arg ~= 4 then
	print("Please provide 4 argumets like so:")
	print("$ tdyadd.lua 10/06/22 8:35 'Some task name' HIGH")
	os.exit()
end

print(arg[1])
print(arg[2])
print(arg[3])
print(arg[4])

---comment
---@param s any
---@return string
---@return string
local function FirstAndLastDigit(s)
	local digits = {}
	for digit in s:gmatch("%d") do
		table.insert(digits, digit)
	end
	return digits[1], digits[#digits]
end

function Main()
	local file = io.open(arg[1], "r")
	if not file then
		error("Could not open file" .. arg[1])
	end

	--- @type string
	local content = file:read("*a"):gsub("^%s+", ""):gsub("%s+$", "")
	file:close()

	local sum = 0
	for line in content:gmatch("[^\r\n]+") do
		local first, last = FirstAndLastDigit(line)
		local number = tonumber(first .. last)
		print(line, number)
		sum = sum + number
	end
	print("Sum of all numbers for part 1: " .. sum)
end
Main()

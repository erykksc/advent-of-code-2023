Digits = {
	["1"] = 1,
	["2"] = 2,
	["3"] = 3,
	["4"] = 4,
	["5"] = 5,
	["6"] = 6,
	["7"] = 7,
	["8"] = 8,
	["9"] = 9,
	one = 1,
	two = 2,
	three = 3,
	four = 4,
	five = 5,
	six = 6,
	seven = 7,
	eight = 8,
	nine = 9,
}

---comment
---@param s string
---@return string
---@return string
local function FirstAndLastDigit(s)
	local idx = 0
	local digits = {} --- @type number[]
	while idx <= #s do
		local digit, startPos, endPos = nil, math.huge, math.huge
		for digitStr, digitValue in pairs(Digits) do
			local foundStartPos, foundEndPos = s:find(digitStr, idx, true)
			if not foundStartPos or not foundEndPos then
				goto continue
			end
			if foundStartPos <= startPos and foundEndPos < endPos then
				digit = digitValue
				startPos = foundStartPos
				endPos = foundEndPos
			end
			::continue::
		end

		if not digit then
			-- There are no digits left
			break
		end
		table.insert(digits, digit)
		idx = idx + 1
	end
	return tostring(digits[1]), tostring(digits[#digits])
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
		local num = tonumber(first .. last)
		print(line, num)
		sum = sum + num
	end
	print("Sum of all numbers for part 2: " .. sum)
end
Main()

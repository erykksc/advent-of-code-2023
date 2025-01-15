local Digits = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" }

local function isDigit(char)
	for _, digit in ipairs(Digits) do
		if char == digit then
			return true
		end
	end
	return false
end

local function adjecent(y, x)
	return {
		{ y = y - 1, x = x - 1 },
		{ y = y - 1, x = x },
		{ y = y - 1, x = x + 1 },
		{ y = y, x = x - 1 },
		{ y = y, x = x + 1 },
		{ y = y + 1, x = x - 1 },
		{ y = y + 1, x = x },
		{ y = y + 1, x = x + 1 },
	}
end

function Main()
	local grid = {} ---@type string[][]

	local height, width = 0, 0
	for line in io.lines(arg[1]) do
		height = height + 1
		grid[height] = {}

		width = 0
		for char in line:gmatch(".") do
			width = width + 1
			grid[height][width] = char
		end
	end

	print("============Input grid============")
	for y, row in ipairs(grid) do
		for x, _ in ipairs(row) do
			io.write(grid[y][x])
		end
		print("")
	end

	print("========Scanning for parts========")
	local partsSum = 0
	local starNums = {}
	local y, x = 1, 1
	while y <= height do
		while x <= width do
			local startPos, endPos = x, x
			local char = grid[y][x]
			local numS = ""
			local isPart = false

			if char == "." then
				goto continue
			end

			-- Is a symbol
			if not isDigit(char) then
				print("Found symbol:", char)
				goto continue
			end

			--Find out how long is the digit
			for i = startPos, width do
				if not isDigit(grid[y][i]) then
					-- it is a symbol or '.'
					endPos = i - 1
					break
				end
				numS = numS .. grid[y][i]
			end

			-- Find all the adjacent symbols
			-- add numbers adjacent to * to starNums[starPos]=tonumber(numS)
			for lX = startPos, endPos do
				for _, adj in ipairs(adjecent(y, lX)) do
					-- check if out of bounds
					if not (adj.y > 0 and adj.x > 0 and adj.y <= height and adj.x <= width) then
						goto continue
					end

					local adjChar = grid[adj.y][adj.x]
					if adjChar ~= "." and not isDigit(adjChar) then
						-- adjChar is a symbol
						isPart = true
					end

					if adjChar == "*" then
						local pointKey = adj.y .. ":" .. adj.x
						if not starNums[pointKey] then
							starNums[pointKey] = {}
						end
						starNums[pointKey][tonumber(numS)] = true
					end
					::continue::
				end
			end

			print("Found number:", numS, "is engine part:", isPart)
			if isPart then
				partsSum = partsSum + tonumber(numS)
			end

			::continue::
			x = endPos + 1
		end
		y = y + 1
		x = 1
	end

	print("========Looking for gears========")
	local gearRatioSum = 0
	for point, numsTable in pairs(starNums) do
		local nums = {}
		for k, _ in pairs(numsTable) do
			table.insert(nums, k)
		end
		print("Engine parts adjacent to * at " .. point, table.concat(nums, ", "))
		if #nums == 2 then
			local gearRatio = nums[1] * nums[2]
			print("Found gear at", point, "gear ratio:", gearRatio)
			gearRatioSum = gearRatioSum + gearRatio
		end
	end

	print("=============Results=============")
	print("Parts sum:", partsSum)
	print("Gear ration sum:", gearRatioSum)
end

Main()

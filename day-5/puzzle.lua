local RangesList = {
	---@param self MyRange[]
	---@param source integer
	---@return number
	__call = function(self, source)
		for _, range in ipairs(self) do
			local diff = source - range.source
			if diff >= 0 and diff <= range.length then
				return range.destination + diff
			end
		end
		return source
	end,
}

---@class MyRange
---@field destination integer
---@field source integer
---@field length integer

---comment
---@param s any
---@return string
---@return MyRange[]
local function parseSection(s)
	local lineId = 1
	local mapName = ""
	local ranges = {}
	for line in (s .. "\n"):gmatch("(.-)\n") do
		if lineId == 1 then
			local spaceId = line:find(" ", 1, true)
			mapName = line:sub(1, spaceId - 1)
		else
			local numId = 1
			local range = {}
			for numStr in (line .. " "):gmatch("(.-) ") do
				if numId == 1 then
					range.destination = tonumber(numStr)
				elseif numId == 2 then
					range.source = tonumber(numStr)
				else
					range.length = tonumber(numStr)
				end
				numId = numId + 1
			end
			table.insert(ranges, range)
		end
		lineId = lineId + 1
	end

	return mapName, ranges
end

local function main()
	if #arg < 1 then
		error("Usage: lua puzzle.lua <input_file>")
	end

	local file = assert(io.open(arg[1]))
	local seedsStr = file:read("*l")
	_ = file:read("*l")
	local sectionsStrs = file:read("*all") --- @type string
	file:close()

	local seeds = {}
	for seedStr in (seedsStr .. " "):gmatch("(.-) ") do
		table.insert(seeds, tonumber(seedStr))
	end

	print("seeds", table.concat(seeds, ", "))

	local maps = {}
	for section in (sectionsStrs .. "\n\n"):gmatch("(.-)\n\n") do
		local mapName, ranges = parseSection(section)
		setmetatable(ranges, RangesList)
		maps[mapName] = ranges

		-- Print out the map and ranges
		print(mapName)
		for _, range in ipairs(ranges) do
			print("range", range.destination, range.source, range.length)
		end
	end

	print("Results for Part 1")
	local minSeed, minLocation = math.huge, math.huge
	for _, seed in ipairs(seeds) do
		local soil = maps["seed-to-soil"](seed)
		local fertilizer = maps["soil-to-fertilizer"](soil)
		local water = maps["fertilizer-to-water"](fertilizer)
		local light = maps["water-to-light"](water)
		local temperature = maps["light-to-temperature"](light)
		local humidity = maps["temperature-to-humidity"](temperature)
		local location = maps["humidity-to-location"](humidity)

		if location < minLocation then
			print("Found new min location (seed, location)", seed, location)
			minSeed = seed
			minLocation = location
		end
	end
	print("Part 1: minSeed, minLocation", minSeed, minLocation)

	-- expand seeds from ranges
	minSeed, minLocation = math.huge, math.huge
	local part2seeds = {}
	local startIdx = 1
	while startIdx < #seeds do
		local start, length = seeds[startIdx], seeds[startIdx + 1]
		for newSeed = start, start + length do
			table.insert(part2seeds, newSeed)
		end
	end

	print("Results for Part 2")
	for _, seed in ipairs(part2seeds) do
		local soil = maps["seed-to-soil"](seed)
		local fertilizer = maps["soil-to-fertilizer"](soil)
		local water = maps["fertilizer-to-water"](fertilizer)
		local light = maps["water-to-light"](water)
		local temperature = maps["light-to-temperature"](light)
		local humidity = maps["temperature-to-humidity"](temperature)
		local location = maps["humidity-to-location"](humidity)

		if location < minLocation then
			print("Found new min location (seed, location)", seed, location)
			minSeed = seed
			minLocation = location
		end
	end
	print("Part 2: minSeed, minLocation", minSeed, minLocation)
end
main()

---@param a number[]
---@param b integer[]
---@return integer[]
local function intersect(a, b)
	local common = {} ---@type integer[]
	table.sort(a)
	table.sort(b)

	local ap, bp = 1, 1
	while ap <= #a and bp <= #b do
		if a[ap] < b[bp] then
			ap = ap + 1
		elseif a[ap] > b[bp] then
			bp = bp + 1
		else
			-- common value
			table.insert(common, a[ap])
			ap = ap + 1
			bp = bp + 1
		end
	end

	return common
end

---@param line string
---@return integer[]
---@return integer[]
local function parseCard(line)
	local start = assert(line:find(": ", 1, true))
	line = line:sub(start + #": ")

	local sep = assert(line:find(" | ", 1, true))
	local winningS = line:sub(1, sep - 1)
	local ownedS = line:sub(sep + #" | ")

	-- parse winning numbers
	local winning = {} ---@type integer[]
	for num in winningS:gmatch("%d+") do
		table.insert(winning, tonumber(num))
	end

	-- parse owned numbers
	local owned = {} ---@type integer[]
	for num in ownedS:gmatch("%d+") do
		table.insert(owned, tonumber(num))
	end

	return winning, owned
end

local function main()
	if #arg >= 1 then
		local file = assert(io.open(arg[1], "r"))
		io.input(file)
	end

	local metaInstances = {}
	function metaInstances:__index(_)
		return 0
	end
	local instances = {}
	setmetatable(instances, metaInstances)

	local totalPoints, totalScratchcards = 0, 0
	local cardId = 0
	for line in io.lines() do
		cardId = cardId + 1

		print(line)

		instances[cardId] = instances[cardId] + 1
		print("You have " .. instances[cardId] .. " instances of this card")
		totalScratchcards = totalScratchcards + instances[cardId]

		local winning, owned = parseCard(line)

		local common = intersect(winning, owned)
		print("common", table.concat(common, " "))

		if #common == 0 then
			goto continue
		end

		local points = math.floor(2 ^ (#common - 1))
		totalPoints = totalPoints + points
		print("Points", points)

		for extraCardId = cardId + 1, cardId + #common do
			print("Won another instance of card " .. extraCardId)
			instances[extraCardId] = instances[extraCardId] + instances[cardId]
		end

		::continue::
	end
	print("Total points: " .. totalPoints)
	print("Total scratchcards won: " .. totalScratchcards)
end
main()

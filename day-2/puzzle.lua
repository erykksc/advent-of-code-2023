#!/usr/bin/env lua

function Main()
	if #arg < 1 then
		error("Not enough arguments provided, need one with the input filename")
	end

	local file = io.open(arg[1], "r")
	if not file then
		error("Could not open file" .. arg[1])
	end

	--- @type string
	local content = file:read("*a"):gsub("^%s+", ""):gsub("%s+$", "")
	file:close()

	local sumOfIds = 0
	local gameId = 0
	local powerSum = 0
	for line in content:gmatch("[^\r\n]+") do
		gameId = gameId + 1
		local _, endPos = line:find(": ", 0, true)
		local cubesStr = line:sub(endPos + 1)

		---@type table<string,number>
		local gameMax = {
			red = 0,
			green = 0,
			blue = 0,
		}

		for game in cubesStr:gmatch("[^;]+") do
			for ball in (game .. ", "):gmatch("(.-), ") do
				local numberS, color = ball:match("(%d+) (%w+)")
				local num = tonumber(numberS)
				print(num, color)
				if gameMax[color] < num then
					gameMax[color] = num
				end
			end
		end
		if gameMax.red <= 12 and gameMax.green <= 13 and gameMax.blue <= 14 then
			sumOfIds = sumOfIds + gameId
		end
		local power = gameMax.red * gameMax.green * gameMax.blue
		print(
			"Game " .. gameId,
			"red:" .. gameMax.red,
			"green:" .. gameMax.green,
			"blue:" .. gameMax.blue,
			"power:" .. power
		)
		powerSum = powerSum + power
	end
	print("Sum of ids", sumOfIds)
	print("Sum of powers", powerSum)
end
Main()

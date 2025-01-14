package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

type Game map[string]int

func ParseGame(line string) []Game {
	parts := strings.SplitN(line, ":", 2)
	_, subsets := parts[0], parts[1]

	// var gameId int
	// _, err := fmt.Sscanf(gameIdStr, "Game %d", &gameId)
	// if err != nil {
	// 	panic(err)
	// }

	subsetsMaps := []Game{}
	for _, subset := range strings.Split(subsets, ";") {
		subsetMap := Game{}
		for _, cubes := range strings.Split(subset, ",") {
			var num int
			var color string
			fmt.Sscanf(cubes, "%d %s", &num, &color)
			subsetMap[color] = num
		}
		subsetsMaps = append(subsetsMaps, subsetMap)
	}
	return subsetsMaps
}

func MaxValues(games []Game) Game {
	max := Game{}
	for _, game := range games {
		for color, num := range game {
			if max[color] < num {
				max[color] = num
			}
		}
	}
	return max
}

func main() {
	file, err := os.Open(os.Args[1])
	if err != nil {
		panic(err)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)

	gameId := 0
	possibleIdsSum := 0
	powerSum := 0
	for scanner.Scan() {
		gameId++
		line := scanner.Text()
		games := ParseGame(line)
		// fmt.Printf("%v\n", games)

		maxGame := MaxValues(games)
		// fmt.Printf("Max values: %v\n", maxGame)

		if maxGame["red"] <= 12 && maxGame["green"] <= 13 && maxGame["blue"] <= 14 {
			possibleIdsSum += gameId
			fmt.Printf("Game %d possible\n", gameId)
		}
		power := maxGame["red"] * maxGame["green"] * maxGame["blue"]
		fmt.Printf("Game %d power: %d\n", gameId, power)
		powerSum += power
	}
	fmt.Printf("Possible games id sum: %d\n", possibleIdsSum)
	fmt.Printf("Sum of powers: %d\n", powerSum)
}

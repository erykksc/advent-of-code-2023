package main

import (
	"fmt"
	"os"
	"slices"
	"strconv"
	"strings"
)

var Digits []rune = []rune{'0', '1', '2', '3', '4', '5', '6', '7', '8', '9'}
var NonSymbols []rune = append([]rune{'.'}, Digits...)

type Position struct {
	y, x int
}

func (p Position) Adj() []Position {
	return []Position{
		{p.y - 1, p.x - 1}, {p.y - 1, p.x}, {p.y - 1, p.x + 1},
		{p.y, p.x - 1}, {p.y, p.x + 1},
		{p.y + 1, p.x - 1}, {p.y + 1, p.x}, {p.y + 1, p.x + 1},
	}
}

func main() {
	inputB, err := os.ReadFile(os.Args[1])
	if err != nil {
		panic(err)
	}
	input := strings.TrimSpace(string(inputB))

	fmt.Printf("Input:\n%s\n\n", input)

	lines := strings.Split(input, "\n")

	height, width := len(lines), len(lines[0])

	// Transform the input into 2d matrix
	grid := make([][]rune, height)
	for y, line := range lines {
		grid[y] = make([]rune, width)
		for x, char := range line {
			grid[y][x] = char
		}
	}

	// gear position -> adjacent numbers
	adj2gear := map[Position][]int{}
	for y := 0; y < height; y++ {
		for x := 0; x < width; x++ {
			// Skip non digits
			if !slices.Contains(Digits, grid[y][x]) {
				continue
			}

			// Encountered a digit, find out the whole number
			sPos := Position{y, x}
			ePos := sPos
			for ePos.x += 1; ePos.x < width; ePos.x++ {
				if slices.Contains(Digits, grid[ePos.y][ePos.x]) {
					continue
				}
				break
			}
			ePos.x -= 1
			fmt.Printf("Found engine part from %v -> %v\n", sPos, ePos)

			// Check if any position of the number is adjacent to a '*' symbol
			isAdj2gear := false
			var gearPos Position
			for pos := sPos; pos.x <= ePos.x; pos.x++ {
				for _, adj := range pos.Adj() {
					// Check if out of bounds
					if adj.y <= 0 || adj.x <= 0 || adj.y >= height || adj.x >= width {
						continue
					}

					adjChar := grid[adj.y][adj.x]
					if adjChar == '*' {
						isAdj2gear = true
						gearPos = Position{adj.y, adj.x}
						break
					}
				}
			}

			if isAdj2gear {
				// Decode the part number
				partNumChars := make([]rune, 0, ePos.x-sPos.x+1)
				for pos := sPos; pos.x <= ePos.x; pos.x++ {
					char := grid[pos.y][pos.x]
					partNumChars = append(partNumChars, char)
				}

				partNum, err := strconv.Atoi(string(partNumChars))
				if err != nil {
					panic(err)
				}

				fmt.Printf("Part %v -> %v (%d) adjacent to gear at %v\n", sPos, ePos, partNum, gearPos)
				adj2gear[gearPos] = append(adj2gear[gearPos], partNum)
			}

			x = ePos.x
		}
	}

	gearRatioSum := 0
	for pos, parts := range adj2gear {
		if len(parts) != 2 {
			// Gear has exactly two
			continue
		}
		gearRatio := parts[0] * parts[1]
		fmt.Printf("Gear ratio at %v: %d\n", pos, gearRatio)

		gearRatioSum += gearRatio
	}
	fmt.Printf("Sum of all gear ratios: %d\n", gearRatioSum)
}

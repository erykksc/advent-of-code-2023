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

func IsPosAdj2Symbol(pos Position, grid [][]rune) bool {
	height, width := len(grid), len(grid[0])
	for _, adj := range pos.Adj() {
		if adj.y <= 0 || adj.x <= 0 || adj.y >= height || adj.x >= width {
			continue
		}
		adjChar := grid[adj.y][adj.x]
		if !slices.Contains(NonSymbols, adjChar) {
			// found a sumbol
			return true
		}
	}
	return false
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

	partsSum := 0
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

			inEngine := false
			for pos := sPos; pos.x <= ePos.x; pos.x++ {
				if IsPosAdj2Symbol(pos, grid) {
					inEngine = true
					break
				}
			}

			if inEngine {
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
				partsSum += partNum

				fmt.Printf("Part %v -> %v in engine: %d!\n", sPos, ePos, partNum)
			}

			x = ePos.x
		}
	}
	fmt.Printf("Sum of parts: %d\n", partsSum)
}

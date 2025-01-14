package main

import (
	"bufio"
	"fmt"
	"math"
	"os"
	"slices"
	"strconv"
	"strings"
)

var DIGITS []rune = []rune{'0', '1', '2', '3', '4', '5', '6', '7', '8', '9'}

var DigitStrs map[string]rune = map[string]rune{
	"one":   '1',
	"two":   '2',
	"three": '3',
	"four":  '4',
	"five":  '5',
	"six":   '6',
	"seven": '7',
	"eight": '8',
	"nine":  '9',
}

func main() {
	file, err := os.Open(os.Args[1])
	if err != nil {
		panic(err)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)

	var numbers []int
	for scanner.Scan() {
		line := scanner.Text()
		fmt.Printf("Scanning line: %s\n", line)

		first, last := math.MaxInt, math.MinInt
		var firstC, lastC rune
		for i, char := range line {
			if !slices.Contains(DIGITS, char) {
				continue
			}
			if i < first {
				first = i
				firstC = char
			}
			if i > last {
				last = i
				lastC = char
			}
		}

		for digitS, digit := range DigitStrs {
			firstIdx := strings.Index(line, digitS)
			if firstIdx != -1 && firstIdx < first {
				first = firstIdx
				firstC = digit
			}

			lastIdx := strings.LastIndex(line, digitS)
			if firstIdx != -1 && lastIdx > last {
				last = lastIdx
				lastC = digit
			}
		}

		numberS := string([]rune{firstC, lastC})

		number, err := strconv.Atoi(numberS)
		if err != nil {
			panic(err)
		}

		numbers = append(numbers, number)
	}

	sum := 0
	for _, num := range numbers {
		sum += num
	}

	fmt.Printf("Sum of numbers: %d\n", sum)
}

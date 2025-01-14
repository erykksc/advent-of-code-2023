package main

import (
	"flag"
	"fmt"
	"os"
	"slices"
	"strconv"
	"strings"
)

func ParseCard(line string) (winning, ownedNumbers []int) {
	// Trim until ':' symbol reached
	numbers := strings.TrimLeftFunc(line, func(r rune) bool { return r != ':' })
	numbers = numbers[1:] // trim ':'

	sides := strings.Split(numbers, " | ")

	for _, numS := range strings.Split(sides[0], " ") {
		if len(numS) == 0 {
			continue
		}
		num, err := strconv.Atoi(numS)
		if err != nil {
			panic(err)
		}

		winning = append(winning, num)
	}

	for _, numS := range strings.Split(sides[1], " ") {
		if len(numS) == 0 {
			continue
		}
		num, err := strconv.Atoi(numS)
		if err != nil {
			panic(err)
		}

		ownedNumbers = append(ownedNumbers, num)
	}

	return
}

func Intersection(a, b []int) []int {
	// sort a and b
	slices.Sort(a)
	slices.Sort(b)

	result := []int{}

	pa := 0
	pb := 0
	for pa < len(a) && pb < len(b) {
		switch {
		case a[pa] < b[pb]:
			pa++
		case a[pa] > b[pb]:
			pb++
		default:
			// They are equal
			result = append(result, a[pa])
			pa++
			pb++
		}
	}
	return result
}

func main() {
	flag.Parse()
	inputB, err := os.ReadFile(flag.Arg(0))
	if err != nil {
		panic(err)
	}
	input := strings.TrimSpace(string(inputB))
	lines := strings.Split(input, "\n")

	instances := make([]int, len(lines))

	totalPoints := 0
	for cardId, line := range lines {
		instances[cardId]++ // Count the original card
		winning, owned := ParseCard(line)
		intersection := Intersection(winning, owned)

		if len(intersection) == 0 {
			fmt.Printf("Card %d has no winning numbers, so it is worth no points.\n", cardId+1)
			continue
		}

		points := 1
		if len(intersection) > 1 {
			points = 2 << (len(intersection) - 2)
		}
		fmt.Printf("Card %d has winning numbers %v, so it is worth %d point.\n", cardId+1, intersection, points)
		totalPoints += points
		for x := cardId + 1; x <= cardId+len(intersection); x++ {
			fmt.Printf("Card %d has won a card %d\n", cardId+1, x+1)
			instances[x] += instances[cardId]
		}
	}
	fmt.Printf("Total points won: %d\n", totalPoints)
	instancesSum := 0
	for cardId, count := range instances {
		fmt.Printf("There were %d instances of card %d\n", count, cardId+1)
		instancesSum += count
	}
	fmt.Printf("Sum of all cards instances: %d\n", instancesSum)
}

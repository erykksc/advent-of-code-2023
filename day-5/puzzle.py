#!/usr/bin/env python3

import sys
from typing import List, NamedTuple, Optional, Tuple


class MyRange(NamedTuple):
    startPos: int
    endPos: int  # end of the range inclusive

    def __str__(self):
        return f"MyRange({self.startPos}:{self.endPos})"

    def overlap(self, r: 'MyRange') -> Optional['MyRange']:
        """
        Returns overlaping range of r1 and r
        """
        a, b = self.startPos, self.endPos
        c, d = r.startPos, r.endPos

        if a <= d and c <= b:
            return MyRange(max(a, c), min(b, d))
        else:
            return None

    def cutout(self, other: 'MyRange') -> List['MyRange']:
        """
        Subtract other from self
        """
        # No overlap
        if not self.overlap(other):
            return [self]

        # Complete overlap
        if other.startPos <= self.startPos and self.endPos <= other.endPos:
            return []

        cutouts = []
        if self.startPos < other.startPos:
            cutouts.append(
                MyRange(self.startPos, min(self.endPos, other.startPos)-1))
        if other.endPos < self.endPos:
            cutouts.append(
                MyRange(1+max(self.startPos, other.endPos), self.endPos))

        return cutouts


class MyMap(NamedTuple):
    dstStart: int
    srcStart: int
    rangeLen: int

    @property
    def sourceEnd(self) -> int:
        return self.srcStart + self.rangeLen-1

    def __repr__(self) -> str:
        return f"MyMap({self.dstStart}:{self.srcStart}:{self.sourceEnd})"


def parseMap(mapStr: str) -> Tuple[str, List[MyMap]]:
    '''
    Parse map lines -> mapName, list of maps
    '''
    lines = mapStr.split("\n")
    lines = list(filter(lambda l: len(l) > 0, lines))
    name = lines[0]
    translationsLines = lines[1:]

    translations: List[MyMap] = list()
    for translationLine in translationsLines:
        translation = list(map(int, translationLine.split()))
        translations.append(MyMap(
            dstStart=translation[0],
            srcStart=translation[1],
            rangeLen=translation[2]
        ))

    translations = sorted(translations, key=lambda x: x.srcStart)

    return name, translations


def applyMaps(maps: List[MyMap], num: int) -> int:
    for dstStart, srcStart, length in maps:
        diff = num - srcStart
        if 0 <= diff and diff <= length:
            return dstStart + diff
    return num


def applyMapsToRanges(maps: List[MyMap], ranges: List[MyRange]) -> List[MyRange]:
    print("Maps to apply:", maps)
    results = list()
    leftRanges = ranges[:]  # Assuming that maps do not overlap
    for m in maps:
        print("Processing map:", m)
        for rang in leftRanges[:]:
            print(f"Processing range: {rang}")
            overlap = rang.overlap(MyRange(m.srcStart, m.sourceEnd))
            if not overlap:
                print(f"Overlap not found")
                continue

            print(f"Overlap found: {overlap}")
            # To replace range with new ranges
            leftRanges.remove(rang)

            # Leave parts of range that are not translated
            stays = rang.cutout(overlap)
            print(f"Leaving parts of a range untranslated: {stays}")
            leftRanges.extend(stays)

            # Add translated part of the range
            offset = overlap.startPos - m.srcStart
            overlapLen = overlap.endPos - overlap.startPos
            translated_start = m.dstStart + offset
            translated_range = MyRange(
                translated_start, translated_start+overlapLen)
            print(f"Translated range: {overlap} -> {translated_range}")
            results.append(translated_range)
    print("Adding left over parts to final results:", leftRanges)
    results.extend(leftRanges)

    return results


def main():
    # Read input file
    if not len(sys.argv) > 1:
        print("No second argument provided")
        return -1
    second_arg = sys.argv[1]
    file = open(second_arg, "r")
    seeds_line = file.readline()
    file.readline()  # absorb an empty line
    input = file.read()
    file.close()

    # Parse seeds
    seeds = list(map(int, seeds_line.split(": ")[1].split()))
    print("seeds:", seeds)
    translationsLines = input.split("\n\n")

    # Parse maps
    mapNames: List[str] = list()
    maps: List[List[MyMap]] = list()
    for tableName, translations in map(parseMap, translationsLines):
        mapNames.append(tableName)
        maps.append(translations)

    for name, m in zip(mapNames, maps):
        print(name, m)

    # Part 1 solution
    translated = seeds.copy()
    for tableName, translations in zip(mapNames, maps):
        translated = list(
            map(lambda x: applyMaps(translations, x), translated))
        print(tableName, translated)
    print("Min location for part 1:", min(translated))

    print("========== Part 2 ==========")
    # Parse seed ranges
    seedRanges: List[MyRange] = list()
    for seedStart, seedLen in zip(seeds[::2], seeds[1::2]):
        newRange = MyRange(
            seedStart,
            seedStart + seedLen-1,
        )
        print(f"New seed range: {newRange}")
        seedRanges.append(newRange)

    # Apply all maps
    for levelMaps in maps:
        seedRanges = applyMapsToRanges(levelMaps, seedRanges)
    seedRanges = list(filter(lambda r: r.startPos < r.endPos, seedRanges))
    seedRanges = sorted(seedRanges, key=lambda r: r.startPos)
    print("Final ranges:", seedRanges)
    print("Min location for part 2:", seedRanges[0].startPos)


main()

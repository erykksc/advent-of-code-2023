#!/usr/bin/env python3

import sys


def main():
    # Read input file
    if not len(sys.argv) > 1:
        print("No second argument provided")
        return -1
    file = open(sys.argv[1], "r")
    times_line = file.readline()
    dists_line = file.readline()
    file.close()

    print("Solution for part 1")
    # parse input
    times = list(map(int, times_line.split()[1:]))
    dists = list(map(int, dists_line.split()[1:]))
    print("times", times)
    print("dists", dists)

    margin_of_error = 1
    for t, d in zip(times, dists):
        # try all the hold times until it no longer works
        beating_times = list()
        for hold_time in range(t):
            time_left = t - hold_time
            total_dist = hold_time*time_left
            if total_dist > d:
                beating_times.append(hold_time)
        print(f"Beating holding times for race {t}, {d}",
              beating_times, "total ways", len(beating_times))
        margin_of_error *= len(beating_times)
    print("Margin of error", margin_of_error)

    print("Solution for part 2")
    # parse input
    time = int(''.join(times_line.split()[1:]))
    dist = int(''.join(dists_line.split()[1:]))
    print("time", time)
    print("dist", dist)

    first_beating_time = -1
    last_beating_time = -1
    for hold_time in range(time):
        time_left = time - hold_time
        total_dist = hold_time*time_left
        if total_dist > dist:
            if first_beating_time == -1:
                first_beating_time = hold_time
            last_beating_time = hold_time
    print(
        f"Beating holding times for race {time}, {dist} is {first_beating_time}:{last_beating_time}")
    print("Margin of error", last_beating_time - first_beating_time + 1)


main()

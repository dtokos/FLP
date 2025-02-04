# coding=utf-8

# Reciprocal cycles
# Problem 26
# https://projecteuler.net/problem=26
#
# A unit fraction contains 1 in the numerator. The decimal representation of the unit fractions with denominators 2 to 10 are given:
# 1/2	= 	0.5
# 1/3	= 	0.(3)
# 1/4	= 	0.25
# 1/5	= 	0.2
# 1/6	= 	0.1(6)
# 1/7	= 	0.(142857)
# 1/8	= 	0.125
# 1/9	= 	0.(1)
# 1/10	= 	0.1
# Where 0.1(6) means 0.166666..., and has a 1-digit recurring cycle. It can be seen that 1/7 has a 6-digit recurring cycle.
# Find the value of d < 1000 for which 1/d contains the longest recurring cycle in its decimal fraction part.

from operator import itemgetter

def main():
	print(longestCycle(10))
	print(longestCycle(1000))

def longestCycle(limit):
	return max(map(lambda n: (n, cycleLength(n)), range(2, limit)), key=itemgetter(1))[0]

def cycleLength(n):
	digitLengths = {}
	digit = 1
	length = 0
	
	while True:
		digitLengths[digit] = length
		digit = digit % n * 10
		length += 1
		if digit in digitLengths:
			return length - digitLengths[digit]

if __name__ == '__main__':
	main()

# coding=utf-8

# Smallest multiple
# Problem 5
# https://projecteuler.net/problem=5
#
# 2520 is the smallest number that can be divided by each of the numbers from 1 to 10 without any remainder.
# What is the smallest positive number that is evenly divisible by all of the numbers from 1 to 20?

from functools import reduce
from math import ceil

def main():
	print(smallestMultiple(10))
	print(smallestMultiple(20))

def smallestMultiple(n):
	return int(reduce(lambda a, b: a * b / gcf(a, b), range(n, 3, -1), 2))

def gcf(a, b):
	greater = max(a, b)
	smaller = min(a, b)

	while greater - smaller > 0:
		diff = greater - smaller
		greater -= ceil(diff / smaller) * smaller
		greater, smaller = (smaller, greater)
		
	return smaller

if __name__ == '__main__':
	main()

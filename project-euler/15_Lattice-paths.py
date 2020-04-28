# coding=utf-8

# Lattice paths
# Problem 15
# https://projecteuler.net/problem=15
#
# Starting in the top left corner of a 2×2 grid, and only being able to move to the right and down, there are exactly 6 routes to the bottom right corner.
# How many such routes are there through a 20×20 grid?

from math import factorial

def main():
	print(latticePaths(2, 2))
	print(latticePaths(20, 20))

def latticePaths(width, height):
	return factorial(width + height) // (factorial(width) * factorial(height))

if __name__ == '__main__':
	main()

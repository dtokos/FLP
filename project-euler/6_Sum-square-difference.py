# coding=utf-8

# Sum square difference
# Problem 6
# https://projecteuler.net/problem=6
#
# The sum of the squares of the first ten natural numbers is,
# 1^2 + 2^2 + ... + 10^2 = 385
# The square of the sum of the first ten natural numbers is,
# (1 + 2 + ... + 10)^2 = 55^2 = 3025
# Hence the difference between the sum of the squares of the first ten natural numbers and the square of the sum is 3025−385=2640.
# Find the difference between the sum of the squares of the first one hundred natural numbers and the square of the sum.

from functools import reduce
from operator import add

def main():
	print(sumSquareDifference(10))
	print(sumSquareDifference(100))

def sumSquareDifference(n):
	return squareOfSum(n + 1) - sumOfSquares(n + 1)

def sumOfSquares(n):
	return reduce(add, map(lambda x: x ** 2, range(n)), 0)

def squareOfSum(n):
	return reduce(add, range(n), 0) ** 2

if __name__ == '__main__':
	main()

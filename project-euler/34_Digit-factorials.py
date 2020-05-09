# coding=utf-8

# Digit factorials
# Problem 34
# https://projecteuler.net/problem=34
#
# 145 is a curious number, as 1! + 4! + 5! = 1 + 24 + 120 = 145.
# Find the sum of all numbers which are equal to the sum of the factorial of their digits.
# Note: as 1! = 1 and 2! = 2 are not sums they are not included.

from math import factorial
from functools import reduce

def main():
	print(sumDigitFactorials())

def sumDigitFactorials():
	factorials = [factorial(i) for i in range(10)]

	def sumFactorials(n):
		return reduce(lambda acc, d: acc + factorials[int(d)], str(n), 0)

	return sum([i for i in range(3, 2540160) if i == sumFactorials(i)])

if __name__ == '__main__':
	main()

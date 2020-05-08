# coding=utf-8

# Pandigital products
# Problem 32
# https://projecteuler.net/problem=32
#
# We shall say that an n-digit number is pandigital if it makes use of all the digits 1 to n exactly once; for example, the 5-digit number, 15234, is 1 through 5 pandigital.
# The product 7254 is unusual, as the identity, 39 × 186 = 7254, containing multiplicand, multiplier, and product is 1 through 9 pandigital.
# Find the sum of all products whose multiplicand/multiplier/product identity can be written as a 1 through 9 pandigital.
# HINT: Some products can be obtained in more than one way so be sure to only include it once in your sum.

from math import log10
from functools import reduce

def main():
	print(pandigitalProducts(5))
	print(pandigitalProducts(9))

def pandigitalProducts(digits):
	ranges = set([(j, i) for i in range(1, digits // 2 + 1) for j in range(1, i + 1) if minDigits(i, j) == digits or maxDigits(i, j) == digits])
	products = set()

	def sumRange(minD, maxD):
		for i in digitRange(minD):
			for j in digitRange(maxD):
				product = i * j
				if isPandigital(str(i) + str(j) + str(product)):
					products.add(product)
	
	for (minD, maxD) in ranges:
		sumRange(minD, maxD)

	return sum(products)

def minDigits(i, j):
	return 2 * i + 2 * j - 1

def maxDigits(i, j):
	return i + j + 2 + int(log10(10 ** i - 1)) + int(log10(10 ** j - 1))

def digitRange(digits):
	return range(int('123456789'[:digits]), int('987654321'[:digits]) + 1)

def isPandigital(n):
	return reduce(lambda m, d: m | 1 << int(d), n, 0) + 2 == 1 << (len(n) + 1)

if __name__ == '__main__':
	main()

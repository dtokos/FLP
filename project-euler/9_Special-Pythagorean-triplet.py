# coding=utf-8

# Special Pythagorean triplet
# Problem 9
# https://projecteuler.net/problem=9
#
# A Pythagorean triplet is a set of three natural numbers, a < b < c, for which,
# a^2 + b^2 = c^2
# For example, 3^2 + 4^2 = 9 + 16 = 25 = 5^2.
# There exists exactly one Pythagorean triplet for which a + b + c = 1000.
# Find the product abc.

from math import sqrt

def main():
	print(specialPythagoreanTriplet(56))
	print(specialPythagoreanTriplet(1000))

def specialPythagoreanTriplet(sumTarget):
	a, b, c = next(filter(lambda t: t[0] + t[1] + t[2] == sumTarget, pythagoreanTripletGenerator(sumTarget)))
	return a * b * c

def pythagoreanTripletGenerator(limit):
	for r in range(2, limit, 2):
		for s, t in factorPairs((r ** 2) / 2):
			a = r + s
			b = r + t
			c = r + s + t
			yield (a, b, c)

def factorPairs(n):
	for i in range(1, int(sqrt(n)) + 1):
		if n % i == 0:
			yield (i, int(n // i))

if __name__ == '__main__':
	main()

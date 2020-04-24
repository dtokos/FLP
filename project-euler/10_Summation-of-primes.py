# coding=utf-8

# Summation of primes
# Problem 10
# https://projecteuler.net/problem=10
#
# The sum of the primes below 10 is 2 + 3 + 5 + 7 = 17.
# Find the sum of all the primes below two million.

from operator import add
from math import sqrt

def main():
	print(sumOfPrimes(10))
	print(sumOfPrimes(2000000))

def sumOfPrimes(limit):
	return sum(primes(limit))

def primes(limit):
	primes = set(range(3, limit + 1, 2))
	primes.add(2)
	
	def removeMultiples(n):
		for x in range(n + n, limit, n):
			if x in primes:
				primes.remove(x)

	for n in range(3, int(sqrt(limit)) + 1):
		if n not in primes:
			continue
		
		removeMultiples(n)

	return primes

if __name__ == '__main__':
	main()

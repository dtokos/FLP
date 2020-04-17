# coding=utf-8

# 10001st prime
# Problem 7
# https://projecteuler.net/problem=7
#
# By listing the first six prime numbers: 2, 3, 5, 7, 11, and 13, we can see that the 6th prime is 13.
# What is the 10 001st prime number?



from functools import reduce
from itertools import islice
from operator import add
from math import ceil

def main():
	print(nthPrime(6))
	print(nthPrime(10001))

def nthPrime(n):
	return next(islice(primeGen(), n - 1, None))

def primeGen():
	primes = []
	seq = [4, 2, 4, 2, 4, 6, 2, 6]
	n = 7

	def isPrime(n):
		for p in primes:
				if n % p == 0:
					return False
		return True

	yield 2
	yield 3
	yield 5
	
	while True:
		for s in seq:
			if isPrime(n):
				yield n
				primes = primes + [n]
			n += s

if __name__ == '__main__':
	main()

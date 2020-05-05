# coding=utf-8

# Quadratic primes
# Problem 27
# https://projecteuler.net/problem=27
#
# Euler discovered the remarkable quadratic formula:
# n^2+n+41
# It turns out that the formula will produce 40 primes for the consecutive integer values 0<=n<=39. However, when n=40,402+40+41=40(40+1)+41 is divisible by 41, and certainly when n=41,412+41+41 is clearly divisible by 41.
# The incredible formula n^2−79n+1601 was discovered, which produces 80 primes for the consecutive values 0<=n<=79. The product of the coefficients, −79 and 1601, is −126479.
# Considering quadratics of the form:
# n2+an+b, where |a|<1000 and |b|≤1000
# where |n| is the modulus/absolute value of n
# e.g. |11|=11 and |−4|=4
# Find the product of the coefficients, a and b, for the quadratic expression that produces the maximum number of primes for consecutive values of n, starting with n=0.

from math import sqrt
from operator import itemgetter

def main():
	print(quadraticPrimes(10))
	print(quadraticPrimes(1000))

def quadraticPrimes(limit):
	primes = primesUntil(limit)
	coeff = max([(a, b, countPrimes(a - (1 if b == 2 else 0), b)) for a in range(-limit + 1, limit, 2) for b in primes], key=itemgetter(2))
	return coeff[0] * coeff[1]

def primesUntil(limit):
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

def countPrimes(a, b):
	n = 0
	while True:
		y = n ** 2 + a * n + b
		if not isPrime(y):
			return n
		n += 1

def isPrime(n):
	if n < 2:
		return False
	elif n % 2 == 0 or n % 3 == 0:
		return n in [2, 3]

	for i in range(5, int(sqrt(n) + 1), 6):
		if n % i == 0 or n % (i + 2) == 0:
			return False

	return True

if __name__ == '__main__':
	main()

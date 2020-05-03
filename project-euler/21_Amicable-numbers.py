# coding=utf-8

# Amicable numbers
# Problem 21
# https://projecteuler.net/problem=21
#
# Let d(n) be defined as the sum of proper divisors of n (numbers less than n which divide evenly into n).
# If d(a) = b and d(b) = a, where a ≠ b, then a and b are an amicable pair and each of a and b are called amicable numbers.
# For example, the proper divisors of 220 are 1, 2, 4, 5, 10, 11, 20, 22, 44, 55 and 110; therefore d(220) = 284. The proper divisors of 284 are 1, 2, 4, 71 and 142; so d(284) = 220.
# Evaluate the sum of all the amicable numbers under 10000.

from math import sqrt
from functools import reduce
from operator import add

def main():
	print(sumAmicableNumbers(1000))
	print(sumAmicableNumbers(10000))

def sumAmicableNumbers(limit):
	return reduce(add, filter(None, map(amicableNumber, range(1, limit))), 0)

def amicableNumber(a):
	b = sumDivisors(a)
	if a == b:
		return None
	a2 = sumDivisors(b)
	return a if a == a2 else None

def sumDivisors(n):
	total = 1
	for i in range(2, int(sqrt(n) + 1)):
		if n % i == 0:
			total += i
			if i != n // i:
				total += n // i

	return total
if __name__ == '__main__':
	main()

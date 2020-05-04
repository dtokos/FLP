# coding=utf-8

# Non-abundant sums
# Problem 23
# https://projecteuler.net/problem=23
#
# A perfect number is a number for which the sum of its proper divisors is exactly equal to the number. For example, the sum of the proper divisors of 28 would be 1 + 2 + 4 + 7 + 14 = 28, which means that 28 is a perfect number.
# A number n is called deficient if the sum of its proper divisors is less than n and it is called abundant if this sum exceeds n.
# As 12 is the smallest abundant number, 1 + 2 + 3 + 4 + 6 = 16, the smallest number that can be written as the sum of two abundant numbers is 24. By mathematical analysis, it can be shown that all integers greater than 28123 can be written as the sum of two abundant numbers. However, this upper limit cannot be reduced any further by analysis even though it is known that the greatest number that cannot be expressed as the sum of two abundant numbers is less than this limit.
# Find the sum of all the positive integers which cannot be written as the sum of two abundant numbers.

from math import sqrt
from array import array
from functools import reduce

def main():
	print(sumNonAbundant(50))
	print(sumNonAbundant(28123))

def sumNonAbundant(limit):
	abundant = list(filter(lambda n: sumDivisors(n) > n, range(1, limit)))
	numbers = array('i', [0] * (limit + 1))
	for i in range(len(abundant)):
		for j in range(i, len(abundant)):
			abundantSum = abundant[i] + abundant[j]
			if abundantSum <= limit:
				numbers[abundantSum] = 1

	total = 0
	for i in range(len(numbers)):
		if numbers[i] == 0:
			total += i

	return total

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

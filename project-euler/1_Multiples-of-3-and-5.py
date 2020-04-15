# coding=utf-8

# Multiples of 3 and 5
# Problem 1
#
# If we list all the natural numbers below 10 that are multiples of 3 or 5, we get 3, 5, 6 and 9. The sum of these multiples is 23.
# Find the sum of all the multiples of 3 or 5 below 1000.

from functools import reduce
from operator import add

def main():
	print(multiples(10))
	print(multiples(1000))

def multiples(limit):
	return reduce(add, filter(lambda n: n % 3 == 0 or n % 5 == 0, range(0, limit)), 0)

if __name__ == '__main__':
	main()

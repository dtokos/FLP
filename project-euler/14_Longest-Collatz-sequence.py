# coding=utf-8

# Longest Collatz sequence
# Problem 14
# https://projecteuler.net/problem=14
#
# The following iterative sequence is defined for the set of positive integers:
# n → n/2 (n is even)
# n → 3n + 1 (n is odd)
# Using the rule above and starting with 13, we generate the following sequence:
# 13 → 40 → 20 → 10 → 5 → 16 → 8 → 4 → 2 → 1
# It can be seen that this sequence (starting at 13 and finishing at 1) contains 10 terms. Although it has not been proved yet (Collatz Problem), it is thought that all starting numbers finish at 1.
# Which starting number, under one million, produces the longest chain?
# NOTE: Once the chain starts the terms are allowed to go above one million.

from operator import itemgetter

def main():
	print(longestCollatz(13))
	print(longestCollatz(1000000))

def longestCollatz(limit):
	return max(collatzGen(limit), key=itemgetter(1))[0]

def collatzGen(limit):
	cache = {}

	def count(n):
		nonlocal cache
		if n in cache:
			return cache[n]
		elif n == 1:
			cache[n] = 1
		elif n % 2 == 0:
			cache[n] = 1 + count(n // 2)
		else:
			cache[n] = 1 + count(3 * n + 1)
		return cache[n]

	for i in range(limit, 1, -1):
		if not i in cache:
			cache[i] = count(i)
		yield (i, cache[i])

if __name__ == '__main__':
	main()

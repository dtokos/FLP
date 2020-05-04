# coding=utf-8

# Lexicographic permutations
# Problem 24
# https://projecteuler.net/problem=24
#
# A permutation is an ordered arrangement of objects. For example, 3124 is one possible permutation of the digits 1, 2, 3 and 4. If all of the permutations are listed numerically or alphabetically, we call it lexicographic order. The lexicographic permutations of 0, 1 and 2 are:
# 012   021   102   120   201   210
# What is the millionth lexicographic permutation of the digits 0, 1, 2, 3, 4, 5, 6, 7, 8 and 9?

from itertools import permutations, islice

def main():
	print(nthPermutation(3, 5))
	print(nthPermutation(10, 1000000))

def nthPermutation(digits, n):
	return ''.join(map(str, next(islice(permutations(range(digits)), n - 1, None))))

if __name__ == '__main__':
	main()

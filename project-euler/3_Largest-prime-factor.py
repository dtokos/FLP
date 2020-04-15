# coding=utf-8

# Largest prime factor
# Problem 3
#
# The prime factors of 13195 are 5, 7, 13 and 29.
# What is the largest prime factor of the number 600851475143 ?

from math import sqrt

def main():
	print(largestPrimeFactor(13195))
	print(largestPrimeFactor(600851475143))

def largestPrimeFactor(n):
	n, mp = skip(n, 2, -1)

	for i in range(3, int(sqrt(n)) + 1, 2):
		n, mp = skip(n, i, mp)

	return n if n > 2 else mp

def skip(n, d, last):
	if n % d != 0:
		return (n, last)

	while n % d == 0:
		n /= d

	return (n, d)

if __name__ == '__main__':
	main()

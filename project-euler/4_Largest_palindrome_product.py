# coding=utf-8

# Largest palindrome product
# Problem 4
#
# A palindromic number reads the same both ways. The largest palindrome made from the product of two 2-digit numbers is 9009 = 91 × 99.
# Find the largest palindrome made from the product of two 3-digit numbers.

from functools import reduce

def main():
	print(largestPalindromeProduct(2))
	print(largestPalindromeProduct(3))

def largestPalindromeProduct(n):
	return reduce(lambda a, b: max(a, b), filter(isPalindrome, productGenerator(repeatDigits(n, 9))), 0)

def repeatDigits(n, v):
	return reduce(lambda a, i: a * 10 + v, range(n), 0)

def productGenerator(n):
	for a in range(n, n // 10, -1):
		for b in range(a, n // 10, -1):
			yield a * b

def isPalindrome(n):
	strN = str(n)
	return strN == strN[::-1]

if __name__ == '__main__':
	main()

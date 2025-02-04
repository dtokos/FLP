# coding=utf-8

# Factorial digit sum
# Problem 20
# https://projecteuler.net/problem=20
#
# n! means n × (n − 1) × ... × 3 × 2 × 1
# For example, 10! = 10 × 9 × ... × 3 × 2 × 1 = 3628800,
# and the sum of the digits in the number 10! is 3 + 6 + 2 + 8 + 8 + 0 + 0 = 27.
# Find the sum of the digits in the number 100!

from math import factorial

def main():
	print(factorialDigitSum(10))
	print(factorialDigitSum(100))

def factorialDigitSum(number):
	return sum([int(n) for n in str(factorial(number))])

if __name__ == '__main__':
	main()

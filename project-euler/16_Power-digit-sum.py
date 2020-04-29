# coding=utf-8

# Power digit sum
# Problem 16
# https://projecteuler.net/problem=16
#
# 2^15 = 32768 and the sum of its digits is 3 + 2 + 7 + 6 + 8 = 26.
# What is the sum of the digits of the number 2^1000?

from functools import reduce

def main():
	print(powerDigitSum(2, 15))
	print(powerDigitSum(2, 1000))

def powerDigitSum(base, exp):
	return reduce(lambda acc, n: acc + int(n), str(base ** exp), 0)

if __name__ == '__main__':
	main()

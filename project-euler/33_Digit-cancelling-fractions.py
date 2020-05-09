# coding=utf-8

# Digit cancelling fractions
# Problem 33
# https://projecteuler.net/problem=33
#
# The fraction 49/98 is a curious fraction, as an inexperienced mathematician in attempting to simplify it may incorrectly believe that 49/98 = 4/8, which is correct, is obtained by cancelling the 9s.
# We shall consider fractions like, 30/50 = 3/5, to be trivial examples.
# There are exactly four non-trivial examples of this type of fraction, less than one in value, and containing two digits in the numerator and denominator.
# If the product of these four fractions is given in its lowest common terms, find the value of the denominator.

from importlib import import_module
gcf = import_module('5_Smallest-multiple').gcf

def main():
	print(digitCancellingFractions())

def digitCancellingFractions():
	nomiProd, denomiProd = 1, 1

	for i in range(1, 10):
		for j in range(1, i):
			for k in range(1, j):
				if (k * 10 + i) * j == (i * 10 + j) * k:
					nomiProd *= k
					denomiProd *= j

	return denomiProd // gcf(nomiProd, denomiProd)

if __name__ == '__main__':
	main()

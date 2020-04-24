# coding=utf-8

import unittest
from importlib import import_module
sumOfPrimes = import_module('10_Summation-of-primes').sumOfPrimes

class Tests(unittest.TestCase):
	def test_result_for_10(self):
		self.assertEqual(sumOfPrimes(10), 17)

	def test_result_for_2000000(self):
		self.assertEqual(sumOfPrimes(2000000), 142913828922)

if __name__ == '__main__':
	unittest.main()

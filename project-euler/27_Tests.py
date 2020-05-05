# coding=utf-8

import unittest
from importlib import import_module
quadraticPrimes = import_module('27_Quadratic-primes').quadraticPrimes

class Tests(unittest.TestCase):
	def test_result_for_10(self):
		self.assertEqual(quadraticPrimes(10), -21)

	def test_result_for_1000(self):
		self.assertEqual(quadraticPrimes(1000), -59231)

if __name__ == '__main__':
	unittest.main()

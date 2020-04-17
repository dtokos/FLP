# coding=utf-8

import unittest
from importlib import import_module
nthPrime = import_module('7_10001st-prime').nthPrime

class Tests(unittest.TestCase):
	def test_result_for_6(self):
		self.assertEqual(nthPrime(6), 13)

	def test_result_for_10001(self):
		self.assertEqual(nthPrime(10001), 104743)

if __name__ == '__main__':
	unittest.main()

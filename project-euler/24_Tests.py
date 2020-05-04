# coding=utf-8

import unittest
from importlib import import_module
nthPermutation = import_module('24_Lexicographic-permutations').nthPermutation

class Tests(unittest.TestCase):
	def test_result_for_3_5(self):
		self.assertEqual(nthPermutation(3, 5), '201')

	def test_result_for_10_1000000(self):
		self.assertEqual(nthPermutation(10, 1000000), '2783915460')

if __name__ == '__main__':
	unittest.main()

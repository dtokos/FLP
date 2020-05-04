# coding=utf-8

import unittest
from importlib import import_module
sumNonAbundant = import_module('23_Non-abundant-sums').sumNonAbundant

class Tests(unittest.TestCase):
	def test_result_for_50(self):
		self.assertEqual(sumNonAbundant(50), 891)

	def test_result_for_28123(self):
		self.assertEqual(sumNonAbundant(28123), 4179871)

if __name__ == '__main__':
	unittest.main()

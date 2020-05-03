# coding=utf-8

import unittest
from importlib import import_module
sumAmicableNumbers = import_module('21_Amicable-numbers').sumAmicableNumbers

class Tests(unittest.TestCase):
	def test_result_for_1000(self):
		self.assertEqual(sumAmicableNumbers(1000), 504)

	def test_result_for_10000(self):
		self.assertEqual(sumAmicableNumbers(10000), 31626)

if __name__ == '__main__':
	unittest.main()

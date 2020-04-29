# coding=utf-8

import unittest
from importlib import import_module
powerDigitSum = import_module('16_Power-digit-sum').powerDigitSum

class Tests(unittest.TestCase):
	def test_result_for_2x15(self):
		self.assertEqual(powerDigitSum(2, 15), 26)

	def test_result_for_2x1000(self):
		self.assertEqual(powerDigitSum(2, 1000), 1366)

if __name__ == '__main__':
	unittest.main()

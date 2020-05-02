# coding=utf-8

import unittest
from importlib import import_module
factorialDigitSum = import_module('20_Factorial-digit-sum').factorialDigitSum

class Tests(unittest.TestCase):
	def test_result_for_10(self):
		self.assertEqual(factorialDigitSum(10), 27)

	def test_result_for_100(self):
		self.assertEqual(factorialDigitSum(100), 648)

if __name__ == '__main__':
	unittest.main()

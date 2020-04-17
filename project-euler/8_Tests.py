# coding=utf-8

import unittest
from importlib import import_module
largestProduct = import_module('8_Largest-product-in-a-series').largestProduct

class Tests(unittest.TestCase):
	def test_result_for_4(self):
		self.assertEqual(largestProduct(4), 5832)

	def test_result_for_13(self):
		self.assertEqual(largestProduct(13), 23514624000)

if __name__ == '__main__':
	unittest.main()

# coding=utf-8

import unittest
from importlib import import_module
largestProduct = import_module('11_Largest-product-in-a-grid').largestProduct

class Tests(unittest.TestCase):
	def test_result_for_3(self):
		self.assertEqual(largestProduct(3), 811502)

	def test_result_for_4(self):
		self.assertEqual(largestProduct(4), 70600674)

if __name__ == '__main__':
	unittest.main()

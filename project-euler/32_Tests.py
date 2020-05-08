# coding=utf-8

import unittest
from importlib import import_module
pandigitalProducts = import_module('32_Pandigital-products').pandigitalProducts

class Tests(unittest.TestCase):
	def test_result_for_5(self):
		self.assertEqual(pandigitalProducts(5), 214)

	def test_result_for_9(self):
		self.assertEqual(pandigitalProducts(9), 45228)

if __name__ == '__main__':
	unittest.main()

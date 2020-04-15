# coding=utf-8

import unittest
from importlib import import_module
multiples = import_module('1_Multiples-of-3-and-5').multiples

class Tests(unittest.TestCase):
	def test_result_for_10(self):
		self.assertEqual(multiples(10), 23)

	def test_result_for_1000(self):
		self.assertEqual(multiples(1000), 233168)

if __name__ == '__main__':
	unittest.main()

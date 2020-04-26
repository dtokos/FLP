# coding=utf-8

import unittest
from importlib import import_module
highlyDivisibleTriangle = import_module('12_Highly-divisible-triangular-number').highlyDivisibleTriangle

class Tests(unittest.TestCase):
	def test_result_for_5(self):
		self.assertEqual(highlyDivisibleTriangle(5), 28)

	def test_result_for_500(self):
		self.assertEqual(highlyDivisibleTriangle(500), 76576500)

if __name__ == '__main__':
	unittest.main()

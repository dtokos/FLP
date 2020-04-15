# coding=utf-8

import unittest
from importlib import import_module
smallestMultiple = import_module('5_Smallest-multiple').smallestMultiple

class Tests(unittest.TestCase):
	def test_result_for_10(self):
		self.assertEqual(smallestMultiple(10), 2520)

	def test_result_for_20(self):
		self.assertEqual(smallestMultiple(20), 232792560)

if __name__ == '__main__':
	unittest.main()

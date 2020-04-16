# coding=utf-8

import unittest
from importlib import import_module
sumSquareDifference = import_module('6_Sum-square-difference').sumSquareDifference

class Tests(unittest.TestCase):
	def test_result_for_10(self):
		self.assertEqual(sumSquareDifference(10), 2640)

	def test_result_for_100(self):
		self.assertEqual(sumSquareDifference(100), 25164150)

if __name__ == '__main__':
	unittest.main()

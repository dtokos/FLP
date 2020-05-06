# coding=utf-8

import unittest
from importlib import import_module
sumSpiralDiagonals = import_module('28_Number-spiral-diagonals').sumSpiralDiagonals

class Tests(unittest.TestCase):
	def test_result_for_5(self):
		self.assertEqual(sumSpiralDiagonals(5), 101)

	def test_result_for_1001(self):
		self.assertEqual(sumSpiralDiagonals(1001), 669171001)

if __name__ == '__main__':
	unittest.main()

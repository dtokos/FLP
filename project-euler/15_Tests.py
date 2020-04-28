# coding=utf-8

import unittest
from importlib import import_module
latticePaths = import_module('15_Lattice-paths').latticePaths

class Tests(unittest.TestCase):
	def test_result_for_2x2(self):
		self.assertEqual(latticePaths(2, 2), 6)

	def test_result_for_20x20(self):
		self.assertEqual(latticePaths(20, 20), 137846528820)

if __name__ == '__main__':
	unittest.main()

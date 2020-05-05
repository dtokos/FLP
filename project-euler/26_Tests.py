# coding=utf-8

import unittest
from importlib import import_module
longestCycle = import_module('26_Reciprocal-cycles').longestCycle

class Tests(unittest.TestCase):
	def test_result_for_10(self):
		self.assertEqual(longestCycle(10), 7)

	def test_result_for_1000(self):
		self.assertEqual(longestCycle(1000), 983)

if __name__ == '__main__':
	unittest.main()

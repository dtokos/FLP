# coding=utf-8

import unittest
from importlib import import_module
longestCollatz = import_module('14_Longest-Collatz-sequence').longestCollatz

class Tests(unittest.TestCase):
	def test_result_for_13(self):
		self.assertEqual(longestCollatz(13), 9)

	def test_result_for_1000000(self):
		self.assertEqual(longestCollatz(1000000), 837799)

if __name__ == '__main__':
	unittest.main()

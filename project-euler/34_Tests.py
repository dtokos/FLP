# coding=utf-8

import unittest
from importlib import import_module
sumDigitFactorials = import_module('34_Digit-factorials').sumDigitFactorials

class Tests(unittest.TestCase):
	def test_result(self):
		self.assertEqual(sumDigitFactorials(), 40730)

if __name__ == '__main__':
	unittest.main()

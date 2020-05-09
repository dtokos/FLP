# coding=utf-8

import unittest
from importlib import import_module
digitCancellingFractions = import_module('33_Digit-cancelling-fractions').digitCancellingFractions

class Tests(unittest.TestCase):
	def test_result(self):
		self.assertEqual(digitCancellingFractions(), 100)

if __name__ == '__main__':
	unittest.main()

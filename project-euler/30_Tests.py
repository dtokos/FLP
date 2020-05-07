# coding=utf-8

import unittest
from importlib import import_module
sumDigitPowers = import_module('30_Digit-fifth-powers').sumDigitPowers

class Tests(unittest.TestCase):
	def test_result_for_4(self):
		self.assertEqual(sumDigitPowers(4), 19316)

	def test_result_for_5(self):
		self.assertEqual(sumDigitPowers(5), 443839)

if __name__ == '__main__':
	unittest.main()

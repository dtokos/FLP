# coding=utf-8

import unittest
from datetime import date
from importlib import import_module
countSundays = import_module('19_Counting-Sundays').countSundays

class Tests(unittest.TestCase):
	def test_result_for_2020_01_01_2021_01_01(self):
		self.assertEqual(countSundays(date(2020, 1, 1), date(2021, 1, 1)), 2)

	def test_result_for_1901_01_01_2000_12_31(self):
		self.assertEqual(countSundays(date(1901, 1, 1), date(2000, 12, 31)), 171)

if __name__ == '__main__':
	unittest.main()

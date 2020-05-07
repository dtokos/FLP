# coding=utf-8

import unittest
from importlib import import_module
sumCoins = import_module('31_Coin-sums').sumCoins

class Tests(unittest.TestCase):
	def test_result_for_100(self):
		self.assertEqual(sumCoins(100), 4563)

	def test_result_for_200(self):
		self.assertEqual(sumCoins(200), 73682)

if __name__ == '__main__':
	unittest.main()

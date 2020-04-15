# coding=utf-8

import unittest
from importlib import import_module
sumOfEvenFib = import_module('2_Even-Fibonacci-numbers').sumOfEvenFib

class Tests(unittest.TestCase):
	def test_result_for_10(self):
		self.assertEqual(sumOfEvenFib(10), 10)

	def test_result_for_4000000(self):
		self.assertEqual(sumOfEvenFib(4000000), 4613732)

if __name__ == '__main__':
	unittest.main()

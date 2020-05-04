# coding=utf-8

import unittest
from importlib import import_module
nDigitFibonacci = import_module('25_1000-digit-Fibonacci-number').nDigitFibonacci

class Tests(unittest.TestCase):
	def test_result_for_900(self):
		self.assertEqual(nDigitFibonacci(900), 4304)

	def test_result_for_1000(self):
		self.assertEqual(nDigitFibonacci(1000), 4782)

if __name__ == '__main__':
	unittest.main()

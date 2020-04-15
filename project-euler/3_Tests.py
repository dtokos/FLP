# coding=utf-8

import unittest
from importlib import import_module
largestPrimeFactor = import_module('3_Largest-prime-factor').largestPrimeFactor

class Tests(unittest.TestCase):
	def test_result_for_13195(self):
		self.assertEqual(largestPrimeFactor(13195), 29)

	def test_result_for_600851475143(self):
		self.assertEqual(largestPrimeFactor(600851475143), 6857)

if __name__ == '__main__':
	unittest.main()

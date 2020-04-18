# coding=utf-8

import unittest
from importlib import import_module
specialPythagoreanTriplet = import_module('9_Special-Pythagorean-triplet').specialPythagoreanTriplet

class Tests(unittest.TestCase):
	def test_result_for_56(self):
		self.assertEqual(specialPythagoreanTriplet(56), 4200)

	def test_result_for_1000(self):
		self.assertEqual(specialPythagoreanTriplet(1000), 31875000)

if __name__ == '__main__':
	unittest.main()

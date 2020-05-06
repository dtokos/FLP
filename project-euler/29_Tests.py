# coding=utf-8

import unittest
from importlib import import_module
distinctPowers = import_module('29_Distinct-powers').distinctPowers

class Tests(unittest.TestCase):
	def test_result_for_5(self):
		self.assertEqual(distinctPowers(5), 15)

	def test_result_for_100(self):
		self.assertEqual(distinctPowers(100), 9183)

if __name__ == '__main__':
	unittest.main()

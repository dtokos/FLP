# coding=utf-8

import unittest
from importlib import import_module
numberLetterCounts = import_module('17_Number-letter-counts').numberLetterCounts

class Tests(unittest.TestCase):
	def test_result_for_5(self):
		self.assertEqual(numberLetterCounts(5), 19)

	def test_result_for_1000(self):
		self.assertEqual(numberLetterCounts(1000), 21124)

if __name__ == '__main__':
	unittest.main()

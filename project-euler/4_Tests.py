# coding=utf-8

import unittest
from importlib import import_module
largestPalindromeProduct = import_module('4_Largest_palindrome_product').largestPalindromeProduct

class Tests(unittest.TestCase):
	def test_result_for_2(self):
		self.assertEqual(largestPalindromeProduct(2), 9009)

	def test_result_for_3(self):
		self.assertEqual(largestPalindromeProduct(3), 906609)

if __name__ == '__main__':
	unittest.main()

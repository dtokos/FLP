# coding=utf-8

import unittest
from importlib import import_module
maximumPathSum = import_module('67_Maximum-path-sum-II').maximumPathSum

class Tests(unittest.TestCase):
	def test_result_for_small_triangle(self):
		self.assertEqual(maximumPathSum([
			[3],
			[7, 4],
			[2, 4, 6],
			[8, 5, 9, 3],
		]), 23)

	def test_result_for_big_triangle(self):
		file = open('67_triangle.txt')
		triangle = [list(map(int, line.strip().split())) for line in file]
		file.close()
		self.assertEqual(maximumPathSum(triangle), 7273)

if __name__ == '__main__':
	unittest.main()

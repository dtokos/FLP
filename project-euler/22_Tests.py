# coding=utf-8

import unittest
from csv import reader
from importlib import import_module
totalNameScores = import_module('22_Names-scores').totalNameScores

class Tests(unittest.TestCase):
	def test_result_for_small_list(self):
		self.assertEqual(totalNameScores(['Heath', 'Lia', 'Anaya', 'Hunter', 'Maximus', 'Hunter', 'Elias', 'Malcolm', 'Ray', 'Zachery']), 3702)

	def test_result_for_big_list(self):
		file = open('22_names.txt')
		names = sorted(list(reader(file))[0])
		file.close()
		self.assertEqual(totalNameScores(names), 871198282)

if __name__ == '__main__':
	unittest.main()

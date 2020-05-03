# coding=utf-8

# Names scores
# Problem 22
# https://projecteuler.net/problem=22
#
# Using names.txt (right click and 'Save Link/Target As...'), a 46K text file containing over five-thousand first names, begin by sorting it into alphabetical order. Then working out the alphabetical value for each name, multiply this value by its alphabetical position in the list to obtain a name score.
# For example, when the list is sorted into alphabetical order, COLIN, which is worth 3 + 15 + 12 + 9 + 14 = 53, is the 938th name in the list. So, COLIN would obtain a score of 938 × 53 = 49714.
# What is the total of all the name scores in the file?

from csv import reader
from math import sqrt
from functools import reduce
from operator import add

def main():
	file = open('22_names.txt')
	names = sorted(list(reader(file))[0])
	file.close()
	print(totalNameScores(['Heath', 'Lia', 'Anaya', 'Hunter', 'Maximus', 'Hunter', 'Elias', 'Malcolm', 'Ray', 'Zachery']))
	print(totalNameScores(names))

def totalNameScores(names):
	return sum([score(name) * (i + 1) for i, name in enumerate(names)])

def score(name):
	return reduce(lambda acc, c: acc + (ord(c.lower()) - ord('a') + 1), name, 0)

if __name__ == '__main__':
	main()

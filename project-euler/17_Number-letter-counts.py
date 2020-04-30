# coding=utf-8

# Number letter counts
# Problem 17
# https://projecteuler.net/problem=17
#
# If the numbers 1 to 5 are written out in words: one, two, three, four, five, then there are 3 + 3 + 5 + 4 + 4 = 19 letters used in total.
# If all the numbers from 1 to 1000 (one thousand) inclusive were written out in words, how many letters would be used?
# NOTE: Do not count spaces or hyphens. For example, 342 (three hundred and forty-two) contains 23 letters and 115 (one hundred and fifteen) contains 20 letters. The use of "and" when writing out numbers is in compliance with British usage.

from itertools import count

def main():
	print(numberLetterCounts(5))
	print(numberLetterCounts(1000))

def numberLetterCounts(limit):
	return sum(map(letterCount, range(1, limit + 1)))

def letterCount(number):
	count = countHundreds(number)
	if number >= 1000:
		count += 3 + 8

	return count

def countHundreds(number):
	counts = {
		'ones': {
			1: len('one'),
			2: len('two'),
			3: len('three'),
			4: len('four'),
			5: len('five'),
			6: len('six'),
			7: len('seven'),
			8: len('eight'),
			9: len('nine'),
		},
		'teens': {
			11: len('eleven'),
			12: len('twelve'),
			13: len('thirteen'),
			14: len('fourteen'),
			15: len('fifteen'),
			16: len('sixteen'),
			17: len('seventeen'),
			18: len('eighteen'),
			19: len('nineteen'),
		},
		'tens': {
			1: len('ten'),
			2: len('twenty'),
			3: len('thirty'),
			4: len('forty'),
			5: len('fifty'),
			6: len('sixty'),
			7: len('seventy'),
			8: len('eighty'),
			9: len('ninety'),
		}
	}

	hundreds = (number % 1000) // 100
	tens = (number % 100) // 10
	ones = number % 10
	count = 0
	
	if hundreds != 0:
		count += counts['ones'][hundreds] + 7
		if tens != 0 or ones != 0:
			count += 3

	if tens != 0:
		if tens == 1 and ones != 0:
			count += counts['teens'][tens * 10 + ones]
		else:
			count += counts['tens'][tens]
			if ones != 0:
				count += counts['ones'][ones]
	elif ones != 0:
		count += counts['ones'][ones]

	return count

if __name__ == '__main__':
	main()

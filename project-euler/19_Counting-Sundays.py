# coding=utf-8

# Counting Sundays
# Problem 19
# https://projecteuler.net/problem=19
#
# You are given the following information, but you may prefer to do some research for yourself.
# 1 Jan 1900 was a Monday.
# Thirty days has September,
# April, June and November.
# All the rest have thirty-one,
# Saving February alone,
# Which has twenty-eight, rain or shine.
# And on leap years, twenty-nine.
# A leap year occurs on any year evenly divisible by 4, but not on a century unless it is divisible by 400.
# How many Sundays fell on the first of the month during the twentieth century (1 Jan 1901 to 31 Dec 2000)?

from functools import reduce
from datetime import date
from dateutil import relativedelta

def main():
	print(countSundays(date(2020, 1, 1), date(2021, 1, 1)))
	print(countSundays(date(1901, 1, 1), date(2000, 12, 31)))

def countSundays(start, end):
	return reduce(lambda acc, d: acc + 1, filter(lambda d: d.weekday() == 6, dateGen(start, end, relativedelta.relativedelta(months=1))), 0)

def dateGen(start, end, delta):
	while start < end:
		yield start
		start += delta

if __name__ == '__main__':
	main()

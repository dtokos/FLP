# coding=utf-8

# Coin sums
# Problem 31
# https://projecteuler.net/problem=31
#
# In the United Kingdom the currency is made up of pound (£) and pence (p). There are eight coins in general circulation:
# 1p, 2p, 5p, 10p, 20p, 50p, £1 (100p), and £2 (200p).
# It is possible to make £2 in the following way:
# 1×£1 + 1×50p + 2×20p + 1×5p + 1×2p + 3×1p
# How many different ways can £2 be made using any number of coins?

def main():
	print(sumCoins(100))
	print(sumCoins(200))

def sumCoins(target):
	coins = [1, 2, 5, 10, 20, 50, 100, 200]
	counts = [1] + [0] * target
	for i in coins:
		for j in range(i, target + 1):
			counts[j] += counts[j - i]

	return counts[target]

if __name__ == '__main__':
	main()

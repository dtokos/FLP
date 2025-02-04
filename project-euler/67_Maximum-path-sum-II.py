# coding=utf-8

# Maximum path sum II
# Problem 67
# https://projecteuler.net/problem=67
#
# By starting at the top of the triangle below and moving to adjacent numbers on the row below, the maximum total from top to bottom is 23.
#    3
#   7 4
#  2 4 6
# 8 5 9 3
# 
# That is, 3 + 7 + 4 + 9 = 23.
# 
# Find the maximum total from top to bottom in triangle.txt (right click and 'Save Link/Target As...'), a 15K text file containing a triangle with one-hundred rows.
# NOTE: This is a much more difficult version of Problem 18. It is not possible to try every route to solve this problem, as there are 299 altogether! If you could check one trillion (1012) routes every second it would take over twenty billion years to check them all. There is an efficient algorithm to solve it. ;o)

def main():
	file = open('67_triangle.txt')
	triangle = [list(map(int, line.strip().split())) for line in file]
	file.close()
	print(maximumPathSum([
		[3],
		[7, 4],
		[2, 4, 6],
		[8, 5, 9, 3],
	]))
	print(maximumPathSum(triangle))

def maximumPathSum(triangle):
	for row in range(len(triangle) - 2, -1, -1):
		for col in range(len(triangle[row])):
			triangle[row][col] += max(triangle[row + 1][col], triangle[row + 1][col + 1])
	return triangle[0][0]

if __name__ == '__main__':
	main()

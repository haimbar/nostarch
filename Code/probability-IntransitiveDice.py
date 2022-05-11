import numpy as np
np.random.seed(2022)
A = [2, 2, 4, 4, 9, 9]
B = [1, 1, 6, 6, 8, 8]
C = [3, 3, 5, 5, 7, 7]
n = 1000
rollA = np.random.choice(A, size=n)
rollB = np.random.choice(B, size=n)
rollC = np.random.choice(C, size=n)
my_list = np.array([rollA, rollB, rollC])
print("Die A gave a value greater than Die B:", np.average(my_list[0,] > my_list[1,]), "\n Die B gave a value greater than Die C:", np.average(my_list[1,] > my_list[2,]), "\n Die C gave a value greater than Die A:", np.average(my_list[2,] > my_list[0,]))

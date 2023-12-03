# this is a proposed solution to the Cloudy Days problem given by Ujjwal Dwivedi
# on HackerEarth
# The solution is given in both Python and Cython

import random

def navigate_cities(N, M, K, C):

    if not 2 <= N <= 10e3: raise IndexError(f"N with value {N} is our of range [2, 10^3].")

    if not 0 <= len(M) <= int((N*(N-1))/2): raise IndexError(f"M with length {len(M)} is out of range [0, {int((N*(N-1))/2)}].")

    if not 1 <= K <= 10e6: raise IndexError(f"K with value {K} is out of range [1, 10^6].")

    if not 1 <= C <= N: raise IndexError(f"C with value {C} is out of range [1, {N}].")

    current = C
    paths = []
    first_iters = []



    while K > 0:
        cities = []
        for i, j in M:
            if ((i, j) in first_iters) or ((j, i) in first_iters):
                continue
            if current == i:
                print(f"({i}, {j})->", end="")
                if (i, j) not in cities:
                    cities.append((i, j))
                    current = j
                    K -= 1
            elif current == j:
                print(f"({j}, {i})->", end="")
                if (j, i) not in cities:
                    cities.append((j, i))
                    current = i
                    K = -1
        
        if  len(cities) > 0:
            print("X")
            first_iter = cities[0]
            if cities[0] in M:
                first_iters.append(first_iter)
            else:
                first_iters.append((first_iter[1], first_iter[0]))
            paths.append(cities)
            current = C
        else:
            break

    return paths

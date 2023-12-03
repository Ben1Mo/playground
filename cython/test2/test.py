import random
import time

from cloudy_days import navigate_cities

if __name__ == "__main__":

    N = int(10e3)
    M = [(random.randint(0, N), random.randint(0, N)) for _ in range(random.randint(1, N))]
    K = random.randint(1, int(10e6))
    C = random.randint(1, N)

    print("# PARAMETERS:")
    print(f"N: {N}")
    print(f"M: {len(M)}")
    print(f"K: {K}")
    print(f"C: {C}")

    start = time.time()
    paths = navigate_cities(N, M, K, C)
    print(f"1. Search time: {time.time()-start}")


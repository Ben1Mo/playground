# Modern implementation of the Pi estimation
# Following the algorithm from Borwein and Jonathan
# In both Python and Cython

import math
import numpy as np


import time
import cython
cimport numpy as cnp

DEBUG=False

def f(y: float) -> float:
    """calcaulte the fraction f of y_k

    Parameters
    ----------
    y: np.float64
        the current y_k value

    Returns
    -------
    np.float64
        the calculated y_k(+1)
    """
    return math.pow((1-math.pow(y, 4)), 1/4)

# python implementation
def borwein_estimate_pi(k: int) -> float:
    """estimate pi to a certain precision k

    Parameters
    ----------
    k : int
        the precision degree that we want to achieve
    
    Returns
    -------
    np.float64
        the estimated values of pi
    """


    # intial a_k and y_k values in the Borwein Jonathan equation
    a_k = 6 - 4 * math.sqrt(2)
    y_k = math.sqrt(2) - 1

    pis = []

    # now we iterate over k to calculate a more precise pi estimation
    for i in range(k):
        # dome debug information if we want
        if DEBUG:
            print(f"y_k: {y_k}")
            print(f"a_k: {a_k}")
            print(f"pi: {1/a_k}\n\n")
            time.sleep(0.5)
        
        # calcualte next y_k
        y_k = (1 - f(y_k))/(1 + f(y_k))
        # calculate next a_k
        a_k = a_k*math.pow((1 + y_k), 4) - math.pow(2, (2*i)+3)*y_k*(1 + y_k + math.pow(y_k, 2))

        pis.append(1./a_k)

    return pis


# cython implementation
def opt_borwein_estimate_pi(int k) -> float:
    """estimate pi to a certain precision k

    Parameters
    ----------
    k : int
        the precision degree that we want to achieve
    
    Returns
    -------
    np.float64
        the estimated value of pi
    """


    # intial a_k and y_k values in the Borwein Jonathan equation
    cdef float a_k = 6 - 4 * math.sqrt(2)
    cdef float y_k = math.sqrt(2) - 1
    cdef float[100] pis

    # now we iterate over k to calculate a more precise pi estimation
    for i in range(k):
        # dome debug information if we want
        if DEBUG:
            print(f"y_k: {y_k}")
            print(f"a_k: {a_k}")
            print(f"pi: {1/a_k}\n\n")
            time.sleep(0.5)
    
        # calcualte next y_k
        y_k = (1 - f(y_k))/(1 + f(y_k))
        # calculate next a_k
        a_k = a_k*math.pow((1 + y_k), 4) - math.pow(2, (2*i)+3)*y_k*(1 + y_k + math.pow(y_k, 2)) 

        pis.append(1./a_k)

    result = [pi for pi in pis[:k]]

    return result

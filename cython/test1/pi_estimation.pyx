# Modern implementation of the Pi estimation
# Following the algorithm from Borwein and Jonathan
# In both Python and Cython

import math
import numpy as np

import time
import cython
cimport numpy as cnp
cimport openmp
from libc.math cimport pow, powf, sqrt
from cython.parallel cimport parallel
from libc.stdlib cimport abort, malloc, free

DEBUG=False

def f(y: float) -> float:
    """calcaulte the fraction f of y_k

    Parameters
    ----------
    y: np.float64
        the current y_k value

    Returns
    -------
    float
        the calculated y_k(+1)
    """
    return math.pow((1-math.pow(y, 4)), 1/4)

# python implementation
def borwein_estimate_pi() -> float:
    """estimate pi to a certain precision k

    Returns
    -------
    list[float]
        the estimated values of pi
    """


    # intial a_k and y_k values in the Borwein Jonathan equation
    a_k = 6 - 4 * math.sqrt(2)
    y_k = math.sqrt(2) - 1

    pis = []
    i = 0

    # now we iterate over k to calculate a more precise pi estimation
    while i < 300:
        # calcualte next y_k
        y_k = (1 - f(y_k))/(1 + f(y_k))
        # calculate next a_k
        a_k = a_k*math.pow((1 + y_k), 4) - math.pow(2, (2*i)+3)*y_k*(1 + y_k + math.pow(y_k, 2))

        pis.append(1./a_k)

        i += 1

    return pis


# cython implementation
def para_borwein_estimate_pi():
    """estimate pi to a certain precision k

    Returns
    -------
    list[float]
        the estimated values of pi
    """

    # intial a_k and y_k values in the Borwein Jonathan equation
    cdef float a_k = 6 - 4 * powf(2, 0.5)
    cdef float y_k = powf(2, 0.5) - 1

    # initialize some calculation parameters
    cdef int i = 0
    cdef size_t size = 300

    # allocate memory for results array
    pis = <float *> malloc(sizeof(float) * size)

    if pis is NULL:
        abort()

    # let's use some prallelism
    with nogil, parallel():
        # now we iterate over size to calculate a more precise pi estimation
        while i < size:
            # calcualte next y_k
            y_k = (1 - powf((1-pow(y_k, 4)), 0.25))/(1 + powf((1-pow(y_k, 4)), 0.25))
            # calculate next a_k
            a_k = a_k*pow((1 + y_k), 4) - pow(2, (2*i)+3)*y_k*(1 + y_k + pow(y_k, 2))
    
            pis[i] = 1./a_k
    
            i = i + 1
    
    result = [pi for pi in pis[:size]]

    free(pis)
    
    return result


# cython parallel implementation
def opt_borwein_estimate_pi():
    """estimate pi to a certain precision k

    Returns
    -------
    list[float]
        the estimated values of pi
    """

    # intial a_k and y_k values in the Borwein Jonathan equation
    cdef float a_k = 6 - 4 * powf(2, 0.5)
    cdef float y_k = powf(2, 0.5) - 1

    # initialize some calculation parameters
    cdef int i = 0
    cdef size_t size = 300
    cdef float[300] pis

    # now we iterate over size to calculate a more precise pi estimation
    while i < size:
        # calcualte next y_k
        y_k = (1 - powf((1-pow(y_k, 4)), 0.25))/(1 + powf((1-pow(y_k, 4)), 0.25))
        # calculate next a_k
        a_k = a_k*pow((1 + y_k), 4) - pow(2, (2*i)+3)*y_k*(1 + y_k + pow(y_k, 2))

        pis[i] = 1./a_k

        i += 1

    result = [pi for pi in pis[:size]]
    return result


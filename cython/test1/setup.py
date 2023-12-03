from setuptools import Extension, setup
from Cython.Build import cythonize

ext_modules = [
        Extension("pi_estimation",
            define_macros=[("NPY_NO_DEPRECATED_API", "NPY_1_7_API_VERSION")],
            sources=["pi_estimation.pyx"],
                libraries=["m"]
            )
        ]

setup(
        name="pi_estimation",
        ext_modules = cythonize(ext_modules)
    )

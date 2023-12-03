from setuptools import Extension, setup
from Cython.Build import cythonize

ext_modules = [
        Extension(
            "pi_estimation",
            define_macros=[("NPY_NO_DEPRECATED_API", "NPY_1_7_API_VERSION")],
            extra_compile_args=["-fopenmp"],
            extra_link_args=["-fopenmp"],
            sources=["pi_estimation.pyx"],
            libraries=["m"]
            )
        ]

setup(
        name="pi_estimation",
        ext_modules = cythonize(ext_modules)
    )

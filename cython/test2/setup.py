from setuptools import Extension, setup
from Cython.Build import cythonize

ext_modules = [
        Extension(
            "cloudy_days",
            define_macros=[("NPY_NO_DEPRECATED_API", "NPY_1_7_API_VERSION")],
            extra_compile_args=["-fopenmp"],
            extra_link_args=["-fopenmp"],
            sources=["cloudy_days.pyx"],
            libraries=["m"]
            )
        ]

setup(
        name="cloudy_days",
        ext_modules = cythonize(ext_modules)
    )

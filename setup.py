#!/usr/bin/env python

from setuptools import setup, Extension
import glob

example_module = Extension('_newmultimaps',
                           extra_compile_args = ['-Wall', '-Ofast', '-g', '-std=c++11', '-funroll-loops', '-Wfatal-errors'],
                           sources = ['newmultimaps.i'] + glob.glob('mmap/prng/*.cpp'),
                           extra_objects = glob.glob('mmap/prng/*.s'),
                           swig_opts = ['-c++'],
                           include_dirs = ['/opt/local/include'],
                           libraries = ['gmp', 'gmpxx', 'mpfr', 'fplll'],
                           library_dirs = ['/opt/local/lib']
                          )

setup(name = 'newmultimaps',
      version = '0.1',
      url = 'https://github.com/stevenengler/new-multilinear-maps',
      ext_modules = [example_module],
      py_modules = ['newmultimaps'],
     )

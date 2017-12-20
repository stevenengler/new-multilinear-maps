#!/usr/bin/env python

from distutils.core import setup, Extension
from distutils.command.build import build
import glob

# need to reorder the build due to SWIG, see here:
# https://stackoverflow.com/a/21236111

class CustomBuild(build):
	sub_commands = [
	        ('build_ext', build.has_ext_modules),
	        ('build_py', build.has_pure_modules),
	        ('build_clib', build.has_c_libraries),
	        ('build_scripts', build.has_scripts),
	      ]

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
      cmdclass={'build': CustomBuild},
      ext_modules = [example_module],
      py_modules = ['newmultimaps'],
     )

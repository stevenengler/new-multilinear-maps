# Python Wrapper for a Proof-of-Concept Implementation of the "New" Multilinear Maps over the Integers

This is a Python wrapper for an implementation of the "new" variant of the cryptographic multilinear maps over the Integers.

This is a fork of the [original repository](https://github.com/tlepoint/new-multilinear-maps), but includes some changes as well as the Python wrapper.

This variant is described in the following article:

[1] J.-S. Coron, T. Lepoint, M. Tibouchi, "New Multilinear Maps over the Integers". Available on http://eprint.iacr.org

and builds upon the following article:

[2] J.-S. Coron, T. Lepoint, M. Tibouchi, "Practical Multilinear Maps over the Integers". Available at http://eprint.iacr.org/2013/183

This C++ proof-of-concept and Python wrapper requires:
- *GMP*: http://gmplib.org/
- *fplll*: (to generate parameters) https://github.com/dstehle/fplll
- *SWIG*: http://www.swig.org/

## Build/Installation

You have two choices for building the library.
1. Makefile - This will build the Python library into the current directory (you will have to install it manually, or set your PYTHONPATH), and also build the `generate_pp` and `key_exchange` programs.
2. Setuptools `setup.py` - This will build and install the Python library into the current Python environment, but not build any other libraries/programs.

### Makefile

You may need to edit the `makefile` to set the include and library directories. Then run `make`. You should see the new files `generate_pp`, `key_exchange`, `_newmultimaps.so`, and `newmultimaps.py` (the first two aren't used by the Python library, but might be useful for testing). To use the Python library, set the PYTHONPATH environment variable to the current directory (containing `_newmultimaps.so` and `newmultimaps.py`), or install the files manually into the Python `site_packages`.

### Setuptools

You may need to edit the `setup.py` file to set the include and library directories. Then run either `pip install .` or `python setup.py install`. The former is recommended since you can then easily `pip uninstall newmultimaps` if desired in the future.

## Using the Python library

In Python, run `import newmultimaps`.

## Running the non-Python programs

If you built the code using the Makefile, you can run the `generate_pp`, `key_exchange` programs if desired.

### To generate the public parameters (requires fplll)

```
$ make generate_pp
$ ./generate_pp -l 52 -k 6 -n 540 -r 52 -e 420
``` 

Explaination of the parameters: *-l* is the expected security level (lambda), *-k* is the multilinearity level (kappa), *-n* is the number of primes used, *-r* is the noise size (rho), *-e* is the size of the factors in the primes (etap). By default, running without argument yields the values of above.

This creates a directory `lambda52-kappa6` with all the public parameters of the multilinear map.

Note that all the arguments must be chosen to ensure sufficient security according to [1] and [2]. This is not performed by our implementation.

### To run a kappa+1 Diffie-Hellman key exchange

```
$ make key_exchange
$ ./key_exchange -l 52 -k 6
``` 

This requires the multilinear maps public parameters (created by `generate_pp`) to be stored in a `lambda52-kappa6` directory. By default, running without argument yields the values of above.

Explaination of the parameters: *-l* is the expected security level (lambda), *-k* is the multilinearity level (kappa).

Note that there is a branch *with-small-parameters* containing small parameters to allow testing without running `generate_pp`.

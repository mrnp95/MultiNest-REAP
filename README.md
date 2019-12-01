# MultiNest-REAP

Python interface for multi-core nested sampling of parameter space for mixing angles, masses and phases and their RG evolution.

## Installation
First of all please install the following pre-requisities.

### Pre-requisities

There are so many pre-requisities which need to work interconnectedly, so the best option is to use a __conda__ environment:

1. `conda create -n multi_reap python=3.7 scipy numpy matplotlib progressbar ipython blas libblas liblapack cmake git fortran-compiler gfortran_linux-64`

2. Install __Mpich__: 
```
$ tar -zxf mpich-X.X.X.tar.gz
$ cd mpich-X.X.X
$ ./configure --enable-shared --prefix=/usr/local/mpich
$ make
$ make install
```
3. Install __mpi4py__:
```
pip install mpi4py 
```
or you can check this link for more installation options: [Click](https://mpi4py.readthedocs.io/en/stable/install.html)

4. Install __MultiNest__: 
```
git clone https://github.com/JohannesBuchner/MultiNest
cd MultiNest/build
cmake ..
make
export LD_LIBRARY_PATH=/my/directory/MultiNest/lib/:$LD_LIBRARY_PATH
```
4. 


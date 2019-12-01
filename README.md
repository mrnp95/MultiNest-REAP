# MultiNest-REAP
Python interface for multi-core nested sampling of parameter space for mixing angles, masses and phases of leptons and quarks, and their RG evolution. For any issues or questions email me at `mrn31@cam.ac.uk`.

## Installation
First of all please install the following pre-requisities.

### Pre-requisities
There are so many pre-requisities which need to work interconnectedly, so the best option is to use a __conda__ environment:

1. Installing __conda__ environment and activating it:
```
$ conda create -n multi_reap python=3.7 scipy numpy matplotlib progressbar ipython blas libblas liblapack cmake git fortran-compiler gfortran_linux-64
$ conda activate multi_reap
```

2. Install __mpich__: 
```
$ tar -zxf mpich-X.X.X.tar.gz
$ cd mpich-X.X.X
$ ./configure --enable-shared --prefix=/usr/local/mpich
$ make
$ make install
```
3. Install __mpi4py__:
```
$ pip install mpi4py 
```
or you can check this link for more installation options: [Click](https://mpi4py.readthedocs.io/en/stable/install.html)

4. Install __MultiNest__: 
```
$ git clone https://github.com/JohannesBuchner/MultiNest
$ cd MultiNest/build
$ cmake ..
$ make
$ export LD_LIBRARY_PATH=/my/directory/MultiNest/lib/:$LD_LIBRARY_PATH
$ export PATH=$PATH:/my/directory/MultiNest/bin/
```

5. Install __Cuba__: 
```
$ git clone https://github.com/JohannesBuchner/cuba/
$ cd cuba
$ ./configure
$ ./makesharedlib.sh
$ export LD_LIBRARY_PATH=/my/directory/cuba/:$LD_LIBRARY_PATH
``` 

6. Install __Pymultinest__:
```
$ pip install pymultinest
```
or you can check this link for more installation options: [Click](http://johannesbuchner.github.io/PyMultiNest/install.html)

-------------------------------------------------------------------------------------------------------------------------------

Now that the required packages are installed, we proceed to installing the __MultiNest-REAP__:

```
$ git clone https://github.com/mrnp95/MultiNest-REAP.git
$ cd MultiNest-REAP
$ ssh bash setup.sh
```

-------------------------------------------------------------------------------------------------------------------------------

## Multi-core running
There is an example script in the `examples` folder that you can run now. In order to run this example using multiple cores of your machine, do as follows: 

```
$ cd ./examples/
$ mpiexec -n 4 python majorana_neutrinos.py
```
You can take a look at the `./examples/majorana_neutrinos.py` to have a better understanding of what's going on behind the scenes. 






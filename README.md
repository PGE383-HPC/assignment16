# Homework Assignment 16


![Assignment 16](https://github.com/PGE383-HPC/assignment16/actions/workflows/main.yml/badge.svg)

Sometimes in parallel computations we need to load data from a disk that is too large to fit into the RAM of a single processor.  When this occurs, we need to do some type of parallel input/output, i.e. we need to load individual partitions of the data onto each processor in the parallel network.  The `Distributed` and `DistributedArrays.jl` packages offer a way to do this.  

We are once again going to use problem of integrating a stress/strain curve as a model problem.  We originally implemented a version of this in [Homework Assignment 9](https://github.com/PGE383-HPC/assignment9),  and then in [Homework Assignment 13](https://github.com/PGE383-HPC/assignment13) we extended that code to make it parallel with [MPI.jl](https://juliaparallel.org/MPI.jl/latest/), and then again in [Homework Assignment 15](https://github.com/PGE383-HPC/assignment15) with [DistributedArrays.jl](https://juliaparallel.org/DistributedArrays.jl/stable/).  In this assignment, we read in independent data files from the `data` directory in parallel and create a `DArray` from the individual partitions.  See the [Constructing Distributed Arrays](https://juliaparallel.org/DistributedArrays.jl/stable/#Constructing-Distributed-Arrays) section of the documentation for information on how to accomplish this.

I've rewritten some of the code to process the stress and strain data separately, that way you don't need to worry about how to distribute multidimensional data (but you'll need to perform the read and creation of the `DArray` twice, once for stress and once for strain).  Your assignment is to complete the Julia module [assignment16.jl](src/assignment16.jl).  Specifically, you must complete the function `read_partitioned_data(basename::String)`. 

The naming convention for the files in the `data` directory is demonstrated in the following example: in the file `data.1.4.csv` -- `data` is the `basename`, `1` indicates the part of the data that should be read into memory on processor 1, and `4` is the total number of processors in the network.

When the script is executed with the following command in the Terminal application from the root of the assignment repository

```bash
$HOME/.juliaup/bin/julia --project=. -e 'using Distributed; addprocs(3, exeflags="--project"); using assignment16; compute_toughness_parallel("./data/data") |> print'
```

it run on `3` processors and will print the toughness value to the screen. Your code should be parallel consistent, i.e. it should produce the exact same answer independent of the number of processors you specify.


## Testing

To see if your answer is correct, run the following command at the Terminal
command line from the repository's root directory

```bash
julia --project=. -e "using Pkg; Pkg.test()"
```

the tests will run and report if passing or failing.

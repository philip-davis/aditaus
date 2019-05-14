#include "adios2/toolkit/profiling/taustubs/tautimer.hpp"
#include <iostream>

#include<mpi.h>

using namespace std;

int main(int argc, char *argv[])
{
    MPI_Init(&argc, &argv);

    cout<<"Starting Timer..."<<endl;

    TAU_START("a");

    for(int i = 0; i < 1024*1024; i++);

    TAU_STOP("a");

    cout<<"Ended timer."<<endl;

    MPI_Barrier(MPI_COMM_WORLD);

    MPI_Finalize();

    return(0);
}

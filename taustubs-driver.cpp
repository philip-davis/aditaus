#include "adios2/toolkit/profiling/taustubs/tautimer.hpp"
#include <iostream>
#include <cstdlib>

#include<mpi.h>

using namespace std;

int main(int argc, char *argv[])
{
    int root = 0;
    int rank, size;
    MPI_Init(&argc, &argv);

    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);    

    if(!rank) {
        cout << "Starting Timer..." <<endl;
        TAU_METADATA("appname", "ADIOS2");
    }
    MPI_Barrier(MPI_COMM_WORLD);

    TAU_METADATA("myRank", to_string(rank).c_str());

    TAU_START("timer_name");

    for(int i = 0; i < 20; i++) {
        stringstream tsname;
        int new_root;        

        //busy wait a while so we can see a gap in the trace
        for(int j = 0; j < 1024; j++) {
            TAU_SAMPLE_COUNTER("rand_sample", 900 + (rand() % 201));
        }

        tsname << "ts" << i;
        TAU_SCOPED_TIMER(tsname.str().c_str());
        

        new_root = rand() % size;
        MPI_Bcast(&new_root, 1, MPI_INT, root, MPI_COMM_WORLD);
        root = new_root;
    }

    TAU_STOP("timer_name");

    for(int j = 0; j < 1024; j++) {
        TAU_SAMPLE_COUNTER("rand_sample", 900 + (rand() % 201));
    }


    MPI_Barrier(MPI_COMM_WORLD);
    

    MPI_Finalize();

    return(0);
}

#/bin/bash -x

atmode=trace

TAU2DIR=`pwd`/tau2
export PATH=$PATH:${TAU2DIR}/x86_64/bin

if [ "$atmode" == "profile" ] ; then
    # Profiling
    export TAU_CALLPATH=1    # turns on call path profiling
    export TAU_CALLPATH_DEPTH=100   # should be deep enough
    export TAU_EBS_KEEP_UNRESOLVED_ADDR=1
    export TAU_PROFILE_PREFIX=driver
    export TAU_PROFILE_FORMAT=merged
elif [ "$atmode" == "trace" ] ; then
    #Tracing
    rm -f ebstrace* driver_trace/*
    export TAU_TRACE=1
    export TRACEDIR=`pwd`/driver_trace
fi

mpirun -n 8 tau_exec -T mpi,pthread -ebs ./taustubs > driver.log 2>&1

if [ "$atmode" == "trace" ] ; then
    cd driver_trace
    tau_treemerge.pl

    tau2slog2 tau.trc tau.edf -o tau.slog2
fi

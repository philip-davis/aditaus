#!/bin/bash -x
#BSUB -P CSC303
#BSUB -J taustubs
#BSUB -o taustubs.o%J
#BSUB -W 00:15
#BSUB -B
#BSUB -nnodes 1

TAU2DIR=${MEMBERWORK}/csc303/tau2
export PATH=$PATH:${TAU2DIR}/ibm64linux/bin


export TAU_CALLPATH=1    # turns on call path profiling
export TAU_CALLPATH_DEPTH=100   # should be deep enough
export TAU_EBS_KEEP_UNRESOLVED_ADDR=1
export TAU_PROFILE_PREFIX=driver
export TAU_PROFILE_FORMAT=merged

jsrun -n 1 -r 1 -a 1 -c 1 tau_exec -T mpi,pthread -ebs ./taustubs > driver.log 2>&1

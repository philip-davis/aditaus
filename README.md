# Using the TAU-based profiling stubs in ADIOS2
1. Installing TAU:
  * `./configure -mpi -pthread -bfd=download`
    * These `configure` options build support for intercepting MPI and individuating thread context. TAU needs binutils, and `bfd=download` tells it to do just download it.
  * `make install`
    * By default, TAU installs in a subdirectory of the source. The subdirectory depends on the architecture, e.g. `x86_64/` on an x86 machine, `ibm64linux` on Summit, etc. This can be customized with `-prefix`.
2. Installing ADIOS2:
  * At present, a shared build of ADIOS2 is **required** for profiling to work.
  * Profiling will be compiled-in as long as a shared build is being done. Profiling can be disabled by passing the `-DADIOS2_USE_Profiling=False` option to cmake.
3. Including the profiling headers:
  * In the ADIOS2 repo, there are distinct bindings for C and C++, and they can be found in `source/adios2/toolkit/profiling/taustubs`.
  * The C bindings require including `taustubs.h`
  * The C++ bindings require including `tautimer.hpp`
  
  

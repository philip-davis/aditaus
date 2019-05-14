# Using the TAU-based profiling stubs in ADIOS2
1. Installing TAU:
  * [TAU2 repo](git@github.com:UO-OACISS/tau2.git)
  * `./configure -mpi -pthread -bfd=download`
    * These `configure` options build support for intercepting MPI and individuating thread context. TAU needs binutils, and `bfd=download` tells it to do just download it.
  * `make install`
    * By default, TAU installs in a subdirectory of the source. The subdirectory depends on the architecture, e.g. `x86_64/` on an x86 machine, `ibm64linux` on Summit, etc. This can be customized with `-prefix`.
2. Installing ADIOS2:
  * [ADIOS2](https://github.com/philip-davis/ADIOS2/tree/profiling-enable) - this is branch where the profilng option works...PR currently in progress.

  At present, a shared build of ADIOS2 is **required** for profiling to work. Profiling will be compiled-in as long as a shared build is being done. Profiling can be disabled by passing the `-DADIOS2_USE_Profiling=False` option to cmake. **NOTE: if my PR hasn't gone through yet, profiling can be enabled by uncommenting ADIOS2/source/adios2/toolkit/profiling/taustubs/tautimer.hpp line 12, and ADIOS2/source/adios2/toolkit/profiling/taustubs/taustubs.h line 13.**
  
3. Including the profiling headers:
  * In the ADIOS2 repo, there are distinct bindings for C and C++, and they can be found in `source/adios2/toolkit/profiling/taustubs`.
  * The C bindings require including `taustubs.h`
  * The C++ bindings require including `tautimer.hpp`
 
 4. The stub interface:
  * `TAU_START(char *name)`/`TAU_STOP(const char *name)`: start/stop a named timer
  * `TAU_START_FUNC()` `TAU_STOP_FUNC()`: start/stop a timer that is named procedurally. These calls cannot be nested within the same scope. **Until my PR goes through, this won't work in C++ on the standard repo**
  * `TAU_SAMPLE_COUNTER(const char *name, double value)`: sample a named value. When profiling, tau will report statistics on value for each value/context (where the context is defined by the inner-most timer running when the sample is taken.)
  * `TAU_METADATA(const char *key, const char *val)`: add metadata to the tau profiling/tracing data.
  * `TAU_REGISTER_THREAD()`: unclear to me what this does. I suspect that this has to do with keeping thread timer context seperate.
  *C++ only:*
  * `TAU_SCOPED_TIMER_FUNC()`: start a timer with a procedurally-generated name that stops when the current scope ends.
  * `TAU_SCOPED_TIMER(const char *name)`: start a named timer that stops when the current scope ends.
  
5. Gathering/using profiling and tracing data
  * The program being profiled must be run in the `tau_exec` wrapper, e.g.:
  
      `mpirun -n 8 tau_exec -T mpi,pthread -ebs ./taustubs`
      
      `-T` passes options about instrumenting classes of functions (in this case, instrument all MPI and pthread functions) in addition to the explicitly created timers.
      `-ebs` enables periodic interrupt-based callstack sampling. This can catch code that holds the program counter for a long time without having to explictly create timers everywhere.
      
  * `tau_exec` behavior is guided by environment variables. Tau can (among other things) generate profiling data (statistics on timers, samples, and events) and tracing data (the story of what happened in each process, roughkly synchronized.)
  * Profiling data is viewed with `paraprof`
  * Tracing data is viewed with `jumpshot`
 
 
  
5. Using the aditaus driver repo
  * Create symbolic links to the `ADIOS2` repo root and `tau2`repo root in the base directory of the aditaus folder. Change the PATH assignemnt in the run script if you set a custom `-prefix` option when building tau.

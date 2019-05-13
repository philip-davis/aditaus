ADIOS2_DIR=${MEMBERWORK}/csc303/ADIOS2
ADIOS2_SRC_DIR=$(ADIOS2_DIR)/source
ADIOS2_BUILD_DIR=$(ADIOS2_DIR)/build
ADIOS2_INC_DIR=$(ADIOS2_DIR)/source
ADIOS2_BIN_INC_DIR=$(ADIOS2_BUILD_DIR)/source
TAUSTUBS_DIR=$(ADIOS2_SRC_DIR)/adios2/toolkit/profiling/taustubs

INC=-I$(ADIOS2_SRC_DIR) -I$(ADIOS2_BIN_INC_DIR)
LIBS=-ldl

taustubs: taustubs-driver.o tautimer.o
	mpic++ -o taustubs taustubs-driver.o tautimer.o -ldl

taustubs-driver.o: taustubs-driver.cpp $(TAUSTUBS_DIR)/tautimer.hpp $(LIBS)
	mpic++ -c taustubs-driver.cpp $(INC)

tautimer.o: $(TAUSTUBS_DIR)/tautimer.hpp $(TAUSTUBS_DIR)/tautimer.cpp
	mpic++ -c $(TAUSTUBS_DIR)/tautimer.cpp $(INC)

clean:
	rm -f *.o taustubs

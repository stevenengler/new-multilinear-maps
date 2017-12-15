# makefile version 20150213
# Tancrede Lepoint
# Public domain.

# To adapt to your settings
INCLUDE_DIRS       = -I/opt/local/include
LIB_DIRS           = -L/opt/local/lib
CXX                = g++
PARALLEL           = no

################################################################################################
# Targets
GENERATE_TARGET         = generate_pp
KEY_EXCHANGE_TARGET     = key_exchange

# flags
CXXFLAGS        = -Wall -Ofast -g -std=c++11 -funroll-loops $(INCLUDE_DIRS)
LDLIBS          = $(LIB_DIRS) -lgmp -lgmpxx -lmpfr
LDLIBS_FPLLL    = $(LIB_DIRS) -lfplll

ifeq ($(PARALLEL),yes)
  CXXFLAGS+= -fopenmp
endif

# Files 
SRCS = $(wildcard mmap/prng/*.cpp)
ASMS = $(wildcard mmap/prng/*.s)

GENERATE_SRCS         = generate_pp.cpp
KEY_EXCHANGE_SRCS     = key_exchange.cpp

# All & targets
all: $(GENERATE_TARGET) $(KEY_EXCHANGE_TARGET)

$(GENERATE_TARGET): $(GENERATE_SRCS) $(SRCS) $(ASMS)
		$(CXX) $(CXXFLAGS) $(INCLUDE_DIRS) -o $@ $^ $(LDLIBS) $(LDLIBS_FPLLL)

$(KEY_EXCHANGE_TARGET): $(KEY_EXCHANGE_SRCS) $(SRCS) $(ASMS)
		$(CXX) $(CXXFLAGS) $(INCLUDE_DIRS) -o $@ $^ $(LDLIBS)

# cleaning
clean:
	$(RM) -r $(GENERATE_TARGET) $(GENERATE_TARGET).dSYM $(KEY_EXCHANGE_TARGET) $(KEY_EXCHANGE_TARGET).dSYM

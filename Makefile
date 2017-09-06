#Compiler and flags
CC = g++
LD = g++
PLAT = arm7
CXXFLAGS := -O3 -Llib -Iinclude
LINKFLAGS := -lcityhash 
#Objects
OBJS := $(patsubst %.cpp, %.o, $(wildcard *.cpp))
OBJS2 := $(patsubst %.cpp, %.so, $(wildcard *.cpp))
CXX=      g++ $(CCFLAGS)

UNIX-ECHO-SERVER= unix-echo-server.o unix-server.o server.o
UNIX-ECHO-CLIENT= unix-echo-client.o unix-client.o client.o
OBJS =      $(UNIX-ECHO-SERVER) $(UNIX-ECHO-CLIENT)

LIBS= -lBloomFilter

CCFLAGS= -g -Wall

#Generate binary name
PROG = TestBloomFilter

#Main target
#all: $(PROG)
all: libBloomFilter.so server client # server.o unix-echo-server unix-echo-client
 

libBloomFilter.so:BloomFilter.cpp
	# $(CXX) $(CXXFLAGS) -fPIC -shared $^ -o lib/$(PLAT)/$@ -lcityhash
	$(CXX) $(CXXFLAGS) -fPIC -shared $^ -o lib/$@ -lcityhash

server: server.cpp
	$(CXX) $(CCFLAGS) $(CXXFLAGS) -o bin/$@ $^ $(LIBS)

client: client.cpp
	$(CXX) $(CCFLAGS) -o bin/$@ $(CXXFLAGS) $^

#bloomd:
#	$(CC) $(CXXFLAGS) -o bloomd bloomd.cpp -lBloomFilter

#server.o:
#	$(CXX) -o server.o server.cc -Llib/$(PLAT)/ -lBloomFilter

# unix-echo-server:$(UNIX-ECHO-SERVER)
	#   $(CXX) -o server $(UNIX-ECHO-SERVER) $(CXXFLAGS) $(LIBS)

# unix-echo-client:$(UNIX-ECHO-CLIENT)
	#   $(CXX) -o client $(UNIX-ECHO-CLIENT) $(CXXFLAGS) $(LIBS)


 
clean:
	rm -rf $(OBJS) $(OJBS:.o=.d) $(PROG) $(OBJS2) lib/* bin/*

# These lines ensure that dependencies are handled automatically.
#%.d:  %.cc
#  $(SHELL) -ec '$(CC) -M $(CPPFLAGS) $< \
#    | sed '\''s/\($*\)\.o[ :]*/\1.o $@ : /g'\'' > $@; \
#    [ -s $@ ] || rm -f $@'

#include $(OBJS:.o=.d)

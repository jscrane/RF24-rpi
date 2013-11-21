#############################################################################
#
# Makefile for librf24-bcm on Raspberry Pi
#
# License: GPL (General Public License)
# Author:  Charles-Henri Hallard 
# Date:    2013/03/13 
#
# Description:
# ------------
# use make all and sudo make install to install the library 
# You can change the install directory by editing the LIBDIR line
#
PREFIX=/usr/local

LIBDIR=$(PREFIX)/lib
LIB=librf24-bcm
LIBNAME=$(LIB).so.1.0

# The recommended compiler flags for the Raspberry Pi
CCFLAGS=-Ofast -mfpu=vfp -mfloat-abi=hard -march=armv6zk -mtune=arm1176jzf-s

all: $(LIB)

$(LIB): RF24.o bcm2835.o 
	g++ -shared -Wl,-soname,$@.so.1 ${CCFLAGS} -o ${LIBNAME} $^
	
RF24.o: RF24.cpp
	g++ -Wall -fPIC ${CCFLAGS} -c $^

bcm2835.o: bcm2835.c
	gcc -Wall -fPIC ${CCFLAGS} -c $^

clean:
	rm -rf *.o ${LIB}.*

install: all
	if ( test ! -d $(PREFIX)/lib ) ; then mkdir -p $(PREFIX)/lib ; fi
	install -m 0755 ${LIBNAME} ${LIBDIR}
	ln -sf ${LIBDIR}/${LIBNAME} ${LIBDIR}/${LIB}.so.1
	ln -sf ${LIBDIR}/${LIBNAME} ${LIBDIR}/${LIB}.so
	ldconfig
	install -m 0644 RF24.h RF24_config.h bcm2835.h $(PREFIX)/include

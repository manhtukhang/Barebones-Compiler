CC=$(CROSS)gcc
LD=$(CROSS)ld
AR=$(CROSS)ar
PKG_CONFIG=$(CROSS)pkg-config
CFLAGS = -g -Wall -Wextra

LDFLAGS = -g
LOADLIBES = -lm

bbvm: bbvm.o

bbvm.o: bbvm.c bbvm.h

clean:
	rm *.o
clear:
	rm bbvm

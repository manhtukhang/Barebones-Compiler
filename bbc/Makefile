# Flags
CC=$(CROSS)gcc
LD=$(CROSS)ld
AR=$(CROSS)ar
PKG_CONFIG=$(CROSS)pkg-config
CFLAGS = -g -Wall -Wextra

YACC = bison
YFLAGS = -d -v -t

LEX = flex
LFLAGS = -d

LDFLAGS = -g
LOADLIBES = -lm

# Output

%.tab.c %.tab.h %.tab.output: %.y
	$(YACC) $(YFLAGS) $<

bbc: barebones_parser.o parser.tab.o scanner.o barebones_utils.o
	$(CC) $(LDFLAGS) barebones_parser.o parser.tab.o scanner.o barebones_utils.o $(LOADLIBES) -o bbc

barebones_parser.o: barebones_parser.c barebones.h parser.tab.h util.h

barebones_utils.o: barebones_utils.c util.h

scanner.o: scanner.l barebones.h util.h parser.tab.h

parser.tab.o: parser.y barebones.h

# Operator
clean:
	rm *.o
	rm parser.tab.*
	rm parser.output
clear:
	rm bbc

#Barebone Makefile
#Author: Peternguyen
#License: GPL v3

all:
	$(MAKE) -C bbc
	$(MAKE) -C bbvm
clean:
	$(MAKE) -C bbc clean
	$(MAKE) -C bbvm clean
clear:
	$(MAKE) -C bbc clear
install:
	mkdir bin
	cp -f bbc/bbc bin
	cp -f bbvm/bbvm bin

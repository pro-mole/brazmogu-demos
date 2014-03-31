#A simple Makefile to create our package

EXECNAME=Breakout0
VERSION=0.1
PACKNAME=$(EXECNAME)-$(VERSION).love

all: $(PACKNAME)

$(PACKNAME): *.lua
	zip -9 -q -r $(PACKNAME) *.lua assets

run: all
	open -n -a love $(PACKNAME)

clean:
	rm -f *.love

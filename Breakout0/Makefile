#A simple Makefile to create our package

EXECNAME=Breakout0
VERSION=0.25
PACKNAME=$(EXECNAME)-$(VERSION).love

all: $(PACKNAME)

$(PACKNAME): *.lua
	zip -9 -q -r $(PACKNAME) *.lua assets

run: *.lua
	open -n -a love ./

clean:
	rm -f *.love
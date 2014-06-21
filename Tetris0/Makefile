#A simple Makefile to create our package

EXECNAME=Tetris0
VERSION=0.3
PACKNAME=$(EXECNAME)-$(VERSION).love

all: $(PACKNAME)

$(PACKNAME): *.lua assets
	zip -9 -q -r $(PACKNAME) *.lua assets
	
run: *.lua assets
	open -n -a love ./

clean:
	rm -f *.love

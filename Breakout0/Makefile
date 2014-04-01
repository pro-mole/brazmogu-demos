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

#Releases
release: $(PACKNAME)
	cp $(PACKNAME) Makefile ../release
	$(MAKE) -C ../release release-dir
	mkdir -p release
	cp -rf ../release/release ./
	rm -rf ../release/release

release-dir: love-win32.zip love-win64.zip love-macosx.zip
	mkdir -p win32 win64 release
	#Win32 Release
	unzip love-win32.zip
	mv love-*-win32/* win32
	rmdir love-*-win32
	make -C win32 --makefile ../Makefile release-win32
	cd win32; zip -m -9 ../release/$(EXECNAME)-$(VERSION)-win32.zip *
	rmdir win32
	#Win64 Release
	unzip love-win64.zip
	mv love-*-win64/* win64
	rmdir love-*-win64
	make -C win64 --makefile ../Makefile release-win64
	cd win64; zip -m -9 ../release/$(EXECNAME)-$(VERSION)-win64.zip *
	rmdir win64
	#Mac OSX Release
	unzip love-macosx.zip
	make -C love.app --makefile ../Makefile release-macosx
	mv love.app $(EXECNAME).app
	zip -m -r -9 release/$(EXECNAME)-$(VERSION)-macosx.zip $(EXECNAME).app
	rm -rf $(EXECNAME).app
	#Linux Release
	zip -m -9 release/$(EXECNAME)-$(VERSION)-linux.zip $(PACKNAME)
	#And done
	rm Makefile

release-win32: love.exe ../$(PACKNAME)
	cat love.exe ../$(PACKNAME) > $(EXECNAME).exe
	rm love.exe

release-win64:
	cat love.exe ../$(PACKNAME) > $(EXECNAME).exe
	rm love.exe

release-macosx:
	cp ../$(PACKNAME) Contents/Resources/
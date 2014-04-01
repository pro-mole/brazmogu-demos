#Release Script
#USAGE: ./love-release.sh <LOVE executable>

if [ $# -lt 1 ]
then
	echo "USAGE: love-release.sh <LOVE executable>"
	exit 0
fi

lovefile=$1
releasedir=$(dirname $1)/release

if [ ! -e $lovefile ]
then
	echo "ERROR: $lovefile no found"
	exit 1
fi

mkdir -p $releasedir
zipname=$(basename ${lovefile%.love})
#echo $zipname

function linux {
	mkdir tmp
	cd tmp
	cp $1 ./
	zip -9 -m $releasedir/$zipname-linux.zip *.love
	cd ..
	rmdir tmp
	echo "DONE!"
}

function macosx {
}

function win32 {
	echo "DONE!"
}

function win64 {
	echo "DONE!"
}

for platform in release/*
do
	platname=`cat $platform/PLATFORM`
	echo "Building $platname release..."
	$(basename $platform) $lovefile
done
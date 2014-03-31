set -x
cp -rf Template "$1"

sed -i -e "s/^EXECNAME.*/EXECNAME=$1/" "$1"/Makefile
set +x
set -x
cp -rf Template "$1"

sed -i "s/^EXECNAME.*/EXECNAME=$1/" "$1"/Makefile
echo $1/release >> .gitignore 
set +x

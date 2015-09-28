#!/bin/sh

BRANCH=travis

set -eu

eval `opam config env`

curl -LOk https://github.com/matsen/pplacer/archive/$BRANCH.zip
unzip $BRANCH.zip
cd pplacer-$BRANCH
make test
make zip
cp pplacer-linux.zip /export

echo "ALL DONE"

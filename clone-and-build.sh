#!/bin/sh

eval `opam config env`

git clone git@github.com:matsen/pplacer.git /build
cd /build
make test
make zip
cp pplacer-linux.zip /export

echo "ALL DONE"

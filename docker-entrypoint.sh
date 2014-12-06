#!/bin/sh

eval `opam config env`

if [ -n "${COMMIT}" ]; then
    git checkout ${COMMIT}
else
    git pull origin
fi

exec $@

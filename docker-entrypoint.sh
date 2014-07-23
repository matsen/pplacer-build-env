#!/bin/sh

eval `opam config env`

if [ -n "${COMMIT}" ]; then
    git checkout ${COMMIT}
else
    git checkout -b dev origin/dev
fi

exec $@

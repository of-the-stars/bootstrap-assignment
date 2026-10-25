#!/usr/bin/env sh

if [ -z "$out" ]; then
    out=.

    echo YUR
fi

mkdir -p $out/dist

cp src/* $out/dist/.
cp -r assets $out/dist/.

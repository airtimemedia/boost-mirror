#!/bin/bash

echo -n "boost-mirror: "
git describe --tags
for i in libs/*; do
  if [ -d ${i} ]; then
    pushd $i > /dev/null
    echo -n "$i: "
    git describe --tags
    popd > /dev/null
  fi
done

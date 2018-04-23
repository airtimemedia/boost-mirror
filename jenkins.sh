#!/bin/bash

# echo our commands so we can see what's happening
set -x

# clean up any gunk
rm -rf boost-release

# prep boost
git submodule update --init --recursive
VERSIONS="`./versions.sh`"  # get all library versions
./bootstrap.sh
./b2 headers

# get the release directory and copy the current version to it
git clone git@github.com:airtimemedia/boost-release
shopt -s extglob
cd boost-release
rm -rf !(.git*)
cd ..
tar -c --exclude '.git*' --exclude "boost-release" --exclude "jenkins.sh" --exclude 'project-config.jam*' . | tar -x -C boost-release

# push the new release
cd boost-release
git add .

git commit -a -F- <<EOF
boost-release build $BUILD_NUMBER

Build URL: ${BUILD_URL}

Versions:
$VERSIONS
EOF

git push


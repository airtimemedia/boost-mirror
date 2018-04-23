#!/bin/bash

# echo our commands so we can see what's happening
set -x

# fail on error
set -e

# clean up any gunk
rm -rf boost-release

# prep boost
git submodule update --init --recursive
VERSIONS="`./versions.sh`"  # get all library versions

# CAR-957: patch boost-test to disable "predef-check" feature not available
# in boost-1.57 (seems to have been added in "predef" lib in 1.58.0
# The check is only disabling a warning, so it's safe to disable
pushd libs/test
patch -p1 --ignore-whitespace << EOF
diff --git a/build/Jamfile.v2 b/build/Jamfile.v2
index 092e0193..3de6b26b 100644
--- a/build/Jamfile.v2
+++ b/build/Jamfile.v2
@@ -4,9 +4,9 @@
 #
 #  See http://www.boost.org/libs/test for the library home page.

-import ../../predef/check/predef
-    : check
-    : predef-check ;
+#import ../../predef/check/predef
+#    : check
+#    : predef-check ;

 project boost/test
     : source-location ../src
@@ -16,7 +16,7 @@ project boost/test
                    <link>shared,<toolset>msvc:<cxxflags>-wd4275
                    <toolset>msvc:<cxxflags>-wd4671
                    <toolset>msvc:<cxxflags>-wd4673
-                   [ predef-check "BOOST_COMP_GNUC >= 4.3.0" : : <cxxflags>-Wno-variadic-macros ]
+                   #[ predef-check "BOOST_COMP_GNUC >= 4.3.0" : : <cxxflags>-Wno-variadic-macros ]
                    <toolset>clang:<cxxflags>-Wno-c99-extensions
                    <toolset>clang:<cxxflags>-Wno-variadic-macros
                    <warnings>all

EOF

popd

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


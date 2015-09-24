#!/bin/sh

# fetch FastBit from the git mirror
git submodule update --init

pushd FastBit

# Use a specific FastBit commit. The next FastBit commit causes the library to crash on 
# a device. The crashing change is totally benign (adds one more method to table.h), but 
# seems to exceed some limitation of clang or the library structure (or something else)
# when targeting the arm arch.
git checkout e9922e3ebabee8dcf67162d356cbaa13b13a864f

# creates the fastbit-config.h file
./configure

# override a few options that seem to cause crashes
echo "#undef HAVE_GCC_ATOMIC32" >> src/fastbit-config.h
echo "#undef HAVE_GCC_ATOMIC64" >> src/fastbit-config.h

# regenerate lexers to fix compilation errors
flex -o src/fromLexer.cc src/fromLexer.ll
flex -o src/selectLexer.cc src/selectLexer.ll
flex -o src/whereLexer.cc src/whereLexer.ll

popd

# build arm and i386 versions of the library

TARGET_NAME="FastBit"
CONFIGURATION="Release"
DEVICE="iphoneos"
SIMULATOR="iphonesimulator"
OUTPUT="build"
LIBRARY_NAME="lib${TARGET_NAME}.a"
HEADERS_DIR="include"

xcodebuild -alltargets clean       

for sdk in ${DEVICE} ${SIMULATOR}
do
  xcodebuild -sdk $sdk -configuration ${CONFIGURATION} -target ${TARGET_NAME} -verbose
done
 
DEVICE_OUTPUT=${OUTPUT}/${CONFIGURATION}-${DEVICE}
SIMULATOR_OUTPUT=${OUTPUT}/${CONFIGURATION}-${SIMULATOR}
UNIVERSAL_OUTPUT="lib"
 
rm -rf "${UNIVERSAL_OUTPUT}"
mkdir -p "${UNIVERSAL_OUTPUT}"
lipo -create -output "${UNIVERSAL_OUTPUT}/${LIBRARY_NAME}" "${DEVICE_OUTPUT}/${LIBRARY_NAME}" "${SIMULATOR_OUTPUT}/${LIBRARY_NAME}"
 
rm -rf "${HEADERS_DIR}"
mkdir -p "${HEADERS_DIR}"
cp ${TARGET_NAME}/src/*.h "${HEADERS_DIR}"


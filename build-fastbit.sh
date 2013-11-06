#!/bin/sh

git submodule update --init

pushd FastBit

# creates the fastbit-config.h file
./configure

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


#!/usr/bin/env bash

set -e

SOURCE_PATH=/src/
BUILD_PATH=$HOME/build

echo "Transferring the source: $SOURCE_PATH -> $BUILD_PATH. Please wait..."
cd $BUILD_PATH && cp -rp $SOURCE_PATH . && cd src
echo

echo "Compiling PhantomJS..." && sleep 1
python build.py --confirm --release --qt-config="-no-pkg-config" --git-clean-qtbase --git-clean-qtwebkit
echo

echo "Stripping the executable..." && sleep 1
ls -l bin/phantomjs
strip bin/phantomjs
echo "Copying the executable..." && sleep 1
ls -l bin/phantomjs
cp bin/phantomjs $SOURCE_PATH
echo

echo "Finished."

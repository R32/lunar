#!/bin/sh
#
rm -rf release
mkdir -p release
cp -R -u lunar test haxelib.json release
chmod -R 777 release
cd release
zip -r release.zip ./
cd ..


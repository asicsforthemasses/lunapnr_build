#!/bin/sh
# https://doc.qt.io/qt-6/linux.html

apt-get -y update && apt-get -y upgrade
apt-get install -y wget cmake build-essential
apt-get install -y git ninja-build
apt-get install -y qt6-base-dev
apt-get install -y qt6-base-dev-tools
apt-get install -y qt6-tools-dev
apt-get install -y libqt6opengl6-dev
apt-get install -y libgl1-mesa-dev
apt-get install -y python3-dev
apt-get install -y libboost-test-dev libboost-filesystem-dev
apt-get install -y libeigen3-dev

git clone https://github.com/asicsforthemasses/LunaPnR.git lunapnr
ls -al
cd lunapnr
git checkout stable

mkdir -p build
cd build
cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DUseCPPCHECK=OFF ..
ninja
cd ..

ls -al ./build/test
ls -al ./build/gui

mkdir /artifacts
cp ./build/test/core/core_test /artifacts/
cp ./build/gui/lunapnr /artifacts/

./build/test/core/core_test >core_test.rpt
cp core_test.rpt /artifacts/

gcc --version >/artifacts/gcc_version.txt
cmake --version >/artifacts/cmake_version.txt
python3 --version >/artifacts/python_version.txt

cd /
tar -czf lunapnr.tgz artifacts

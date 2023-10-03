#!/bin/sh
# https://doc.qt.io/qt-6/linux.html
# https://pkgs.org/search
# https://doc.qt.io/qt-6/linux-building.html
# https://wiki.qt.io/Building_Qt_6_from_Git

yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install -y centos-release-scl-rh
yum install -y devtoolset-11
source /opt/rh/devtoolset-11/enable

yum install -y openssl-devel
yum install -y perl
yum install -y ninja-build wget boost-devel git
yum install -y python3-devel
yum install -y eigen3-devel

#############################################################################
# Build CMake from source
#############################################################################

wget https://cmake.org/files/v3.20/cmake-3.20.6.tar.gz
tar zxvf cmake-3.20.6.tar.gz
cd cmake-3.20.6
./bootstrap --prefix=/usr/local
make -j$(nproc)
make install

#############################################################################
# Build Qt6 from source
#############################################################################

mkdir qt6
cd qt6
wget --no-check-certificate https://download.qt.io/official_releases/qt/6.2/6.2.4/single/qt-everywhere-src-6.2.4.tar.xz
tar xf qt-everywhere-src-6.2.4.tar.xz

cd ..
mkdir qt6-build
cd qt6-build
../qt6/qt-everywhere-src-6.2.4/configure
cmake --build . --parallel 4
cmake --install .

#############################################################################
# Build LunaPnR
#############################################################################

git clone https://github.com/asicsforthemasses/LunaPnR.git lunapnr
ls -al
cd lunapnr
git checkout stable

mkdir -p build
cd build
cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DUseCPPCHECK=OFF ..
ninja
cd ..

#############################################################################
# Bundling artifacts
#############################################################################

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

bash

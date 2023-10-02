#!/bin/sh
# https://doc.qt.io/qt-6/linux.html
# https://pkgs.org/search

yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm

# enable CRB repo
dnf config-manager --set-enabled crb
dnf --enablerepo=crb install -y ninja-build

yum install -y wget cmake git
yum install -y qt6-qtbase-devel
yum install -y mesa-libGL-devel
yum install -y python3-devel
yum install -y boost-test boost-filesystem boost-devel
yum install -y eigen3-devel

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

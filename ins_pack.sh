#!/bin/bash

apt-get update -y && apt-get install -y \
    wget curl gnupg locales tzdata software-properties-common unzip upx
     
locale-gen en_US.UTF-8 zh_CN.UTF-8 

TZ=Asia/Chongqing
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# nodejs begin
curl -sL https://deb.nodesource.com/setup_11.x | bash - 

apt-get update && apt-get install -y nodejs build-essential g++ gcc-8 g++-8 default-jdk

update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 700 --slave /usr/bin/g++ g++ /usr/bin/g++-7
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 800 --slave /usr/bin/g++ g++ /usr/bin/g++-8

npm install -g cordova
mkdir -p /data/android
SDKTOOLS=sdk-tools-linux-4333796.zip
GRADLE=gradle-5.3.1-bin.zip
cd /tmp
wget "https://dl.google.com/android/repository/$SDKTOOLS"
wget "https://downloads.gradle.org/distributions/$GRADLE"
unzip -d /data/android/ $SDKTOOLS 
unzip -d /data/android/ $GRADLE 
export PATH="$PATH:/data/android/tools/bin:/data/android/gradle-5.3.1/bin"
yes | sdkmanager "platform-tools" "platforms;android-28" "ndk-bundle" "build-tools;28.0.3" "cmake;3.10.2.4988404"
# wget https://dl.bintray.com/boostorg/release/1.69.0/source/boost_1_69_0.tar.bz2
# tar jxf boost*.tar.bz2
# cd boost_1_69_0 && ./bootstrap.sh
# ./b2 threading=multi threadapi=pthread link=static runtime-link=static install
# cd ..
# # rm -rf boost*
# wget https://github.com/Kitware/CMake/releases/download/v3.14.1/cmake-3.14.1-Linux-x86_64.tar.gz
# tar zxf cmake*.tar.gz
# cd cmake-3.14.1-Linux-x86_64
# cp -r bin /usr/
# cp -r share /usr/
# cp -r doc /usr/share/
# cp -r man /usr/share/
# cd ..
# # rm -rf cmake-3.14.1-Linux-x86_64*
rm -rf *
rm -- "$0"
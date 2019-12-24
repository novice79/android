#!/bin/bash

apt-get update -y && apt-get install -y \
    wget curl gnupg git locales tzdata software-properties-common unzip upx
     
locale-gen en_US.UTF-8 zh_CN.UTF-8 

TZ=Asia/Chongqing
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# nodejs begin
curl -sL https://deb.nodesource.com/setup_12.x | bash - 

apt-get update && apt-get install -y nodejs build-essential g++ gcc-8 g++-8 openjdk-8-jdk-headless

update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 700 --slave /usr/bin/g++ g++ /usr/bin/g++-7
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 800 --slave /usr/bin/g++ g++ /usr/bin/g++-8

npm install -g cordova
mkdir -p /data/android /data/workspace
SDKTOOLS=sdk-tools-linux-4333796.zip
GV=gradle-6.0.1
GRADLE=$GV-bin.zip
cd /tmp
wget "https://dl.google.com/android/repository/$SDKTOOLS"
wget "https://downloads.gradle.org/distributions/$GRADLE"
unzip -d /data/android/ $SDKTOOLS 
unzip -d /data/android/ $GRADLE 
export PATH="$PATH:/data/android/tools/bin:/data/android/$GV/bin"
export ANDROID_SDK_ROOT=/data/android
yes | sdkmanager "platform-tools" "platforms;android-28" "build-tools;29.0.2" "ndk-bundle" "cmake;3.10.2.4988404"
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
cd /data/workspace
# printf 'n\n' | cordova create myapp
cordova telemetry off
cordova create myapp
cd myapp
cordova platform add android
cordova build android
mv /data/workspace/myapp/platforms/android/app/build/outputs/apk/debug/app-debug.apk /data/workspace/test.apk
rm -- "$0"
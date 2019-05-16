FROM novice/git:latest

COPY ins_pack.sh /ins_pack.sh
RUN /ins_pack.sh

ENV PATH "$PATH:/data/android/tools:/data/android/platform-tools:/data/android/tools/bin:/data/android/ndk-bundle:/data/android/gradle-5.3.1/bin"
ENV ANDROID_SDK_ROOT /data/android
ENV LC_ALL en_US.UTF-8   
COPY kp /root/.ssh
WORKDIR /data/workspace


FROM ubuntu:latest
LABEL maintainer="David <david@cninone.com>"

# Get noninteractive frontend for Debian to avoid some problems:
#    debconf: unable to initialize frontend: Dialog
ARG DEBIAN_FRONTEND=noninteractive
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  

COPY main.py /tmp/main.py
COPY ins_pack.sh /ins_pack.sh
RUN /ins_pack.sh

ENV PATH "$PATH:/data/android/tools/bin:/data/android/gradle-5.3.1/bin"
ENV ANDROID_HOME /data/android
ENV LC_ALL en_US.UTF-8   

# ENTRYPOINT ["/init.sh"]

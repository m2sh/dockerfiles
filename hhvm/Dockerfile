FROM debian:jessie

MAINTAINER Mohammad Shahgolzadeh <m2shm2sh@gmail.com>

# install hhvm
RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x5a16e7281be7a449

RUN apt-get update -y && apt-get install -y software-properties-common \
  && add-apt-repository "deb http://dl.hhvm.com/debian jessie main" \
  && apt-get update -y \
  && apt-get install -y hhvm \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/

# install git
RUN apt-get update -y \
    && apt-get install -y git \ 
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/

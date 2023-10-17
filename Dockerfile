FROM ubuntu

ENV DEBIAN_FRONTEND interactive

RUN apt update && apt install -y pkg-config software-properties-common git build-essential libzstd-dev && add-apt-repository ppa:ubuntu-toolchain-r/test -y && apt update

RUN apt update && apt install -y libreadline-dev libssl-dev python3-dev libzstd-dev bison \
    ccache \
    cmake \
    iproute2 \
    curl \
    flex \
    sudo \
    git-core \
    gcc \
    g++ \
    inetutils-ping \
    krb5-kdc \
    krb5-admin-server \
    libapr1-dev \
    libbz2-dev \
    libcurl4-gnutls-dev \
    libevent-dev \
    libkrb5-dev \
    libpam-dev \
    libperl-dev \
    libreadline-dev \
    libssl-dev \
    libxerces-c-dev \
    libxml2-dev \
    libyaml-dev \
    libzstd-dev \
    locales \
    net-tools \
    ninja-build \
    openssh-client \
    openssh-server \
    openssl \
    pkg-config \
    python3-dev \
    python3-pip \
    python3-psycopg2 \
    python3-psutil \
    python3-yaml \
    zlib1g-dev \
    rsync \
    lsof

RUN ssh-keygen -A && mkdir /run/sshd && useradd -m gpdb && \
    usermod -G sudo gpdb && \
    echo "gpdb ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/gpdb && \
    usermod --password $(echo gpdb | openssl passwd -1 -stdin) gpdb
    
USER gpdb

RUN ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa && \
    cp ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys

WORKDIR /tmp

RUN git clone https://github.com/greenplum-db/gpdb/ gpdb && cd gpdb && git submodule init

WORKDIR /tmp/gpdb

RUN ./configure --with-perl --with-python --with-libxml --with-gssapi --prefix=/usr/local/gpdb && make -j8

RUN sudo make install

ENV PATH /usr/local/gpdb/bin:/usr/local/gpdb/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/bin:/sbin

ENV USER gpdb

ENTRYPOINT /bin/bash

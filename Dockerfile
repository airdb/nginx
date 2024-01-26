FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive
ARG OPENSSL_VERSION=OpenSSL_1_1_1-stable
ARG NGINX_VERSION=release-1.23.1

RUN apt update && \
    apt install --no-install-recommends -y \
    vim git curl \
    wget patch dos2unix mercurial \
    liblua5.4-dev unzip dh-autoreconf \
    ca-certificates \
    make gcc zlib1g-dev libpcre3-dev
#    rm -rf /var/cache/apt/archives /var/lib/apt/lists/*



WORKDIR /build

RUN git clone -b master https://github.com/openresty/openresty && \
    cd openresty && \
    make all

RUN git clone --depth=1 -b ${OPENSSL_VERSION} --depth=1 https://github.com/openssl/openssl && \
    git clone --depth=1 -b ${NGINX_VERSION} --depth=1 https://github.com/nginx/nginx && \
    git clone --depth=1 -b master  https://github.com/ip2location/ip2location-nginx && \
    git clone --depth=1 -b master https://github.com/ipipdotnet/nginx-ipip-module && \
    git clone --depth=1 -b master https://github.com/phuslu/nginx-ssl-fingerprint && \
    git clone --depth=1 -b master https://github.com/chrislim2888/IP2Location-C-Library

RUN cd IP2Location-C-Library && \
    autoreconf -i -v --force && \
    ./configure && \
    make && \
    make install



WORKDIR /etc/lua/lib/

RUN git clone --depth=1 -b master https://github.com/ledgetech/lua-resty-http  && \
        git clone --depth=1 -b master https://github.com/openresty/lua-resty-dns

COPY openresty_1.25.3.1_nginx.patch  /build/nginx-ssl-fingerprint/patches/openresty_1.25.3.1_nginx.patch

COPY build.bash /tmp/
RUN bash /tmp/build.bash
CMD ["nginx", "-g", "daemon off;"]
#CMD sleep 3600

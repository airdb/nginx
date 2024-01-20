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

RUN git clone --depth=1 -b ${OPENSSL_VERSION} https://github.com/openssl/openssl && \
    git clone --depth=1 -b ${NGINX_VERSION} https://github.com/nginx/nginx && \
    git clone --depth=1 -b master  https://github.com/ip2location/ip2location-nginx && \
    git clone --depth=1 -b master https://github.com/ipipdotnet/nginx-ipip-module && \
    git clone --depth=1 -b master https://github.com/openresty/openresty && \
    git clone --depth=1 -b master --depth=1 https://github.com/phuslu/nginx-ssl-fingerprint && \
    git clone --depth=1 -b v2.1 https://github.com/LuaJIT/LuaJIT && \
    git clone --depth=1 -b v0.10.26 https://github.com/openresty/lua-nginx-module && \
    git clone --depth=1 -b master https://github.com/FRiCKLE/ngx_cache_purge && \
    git clone -b master https://github.com/chrislim2888/IP2Location-C-Library


RUN cd IP2Location-C-Library && \
    autoreconf -i -v --force && \
    ./configure && \
    make && \
    make install

RUN cd /build/LuaJIT && \
    make && \
    make install
#   69  make PREFIX=/build/LuaJIT &&  make install PREFIX=/usr/local/lib/



WORKDIR /build/openresty

#RUN make && \
#	cd openresty-1.25.3.1
#ADD patches/ /build/nginx-ssl-fingerprint/patches/
#ADD src/ /build/nginx-ssl-fingerprint/src/
#ADD config nginx.conf /build/nginx-ssl-fingerprint/

#RUN patch -p1 -d openssl < nginx-ssl-fingerprint/patches/openssl.1_1_1.patch && \
#    patch -p1 -d nginx < nginx-ssl-fingerprint/patches/nginx.patch && \
#    cd nginx && \
#    ASAN_OPTIONS=symbolize=1 ./auto/configure --with-openssl=$(pwd)/../openssl --add-module=$(pwd)/../nginx-ssl-fingerprint --with-http_ssl_module --with-stream_ssl_module --with-debug --with-stream --with-cc-opt="-fsanitize=address -O -fno-omit-frame-pointer" --with-ld-opt="-L/usr/local/lib -Wl,-E -lasan" && \
#    make

#./configure --add-module=/absolute/path/to/nginx-ip2location-master

#CMD ["nginx-debug", "-g", "daemon off;"]
CMD sleep 3600

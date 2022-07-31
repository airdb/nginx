#!/bin/bash

BUILD_DIR=/build

wget https://openresty.org/download/openresty-1.21.4.1.tar.gz
tar -zxvf openresty-1.21.4.1.tar.gz

wget https://sourceforge.net/projects/pcre/files/pcre/8.45/pcre-8.45.tar.gz
tar -xvf pcre-8.45.tar.gz

wget https://www.openssl.org/source/openssl-1.1.1f.tar.gz
tar -zvxf openssl-1.1.1f.tar.gz

wget https://github.com/phuslu/nginx-ssl-fingerprint/archive/refs/tags/v0.3.0.tar.gz
tar -zvxf v0.3.0.tar.gz

cd ${BUILD_DIR}/openssl-1.1.1f/
patch -p1 < ${BUILD_DIR}/openresty-1.21.4.1/patches/openssl-1.1.1f-sess_set_get_cb_yield.patch

cd ${BUILD_DIR}/
patch -f -p1 -d openssl-1.1.1f <nginx-ssl-fingerprint-0.3.0/patches/openssl.1_1_1.patch
patch -f -p1 -d openresty-1.21.4.1/bundle/nginx-1.21.4 <nginx-ssl-fingerprint-0.3.0/patches/nginx.patch

cd ${BUILD_DIR}/openresty-1.21.4.1/

## assuming your have 4 spare logical CPU cores
./configure \
	--with-debug \
	--with-openssl=${BUILD_DIR}/openssl-1.1.1f \
	--with-pcre=${BUILD_DIR}/pcre-8.45 -j2 \
	--add-module=${BUILD_DIR}/nginx-ssl-fingerprint-0.3.0 && \
make -j4

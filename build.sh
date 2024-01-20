#!/bin/bash

BUILD_DIR=/build

cd ${BUILD_DIR}


OPENSSL_VERSION=OpenSSL_1_1_1-stable
NGINX_VERSION=release-1.23.1


function download() {
    git clone -b ${OPENSSL_VERSION} --depth=1 https://github.com/openssl/openssl && \
    git clone -b ${NGINX_VERSION} --depth=1 https://github.com/nginx/nginx && \
    git clone -b master  https://github.com/ip2location/ip2location-nginx && \
    git clone -b master https://github.com/ipipdotnet/nginx-ipip-module && \
    git clone -b master https://github.com/openresty/openresty && \
    git clone -b master https://github.com/chrislim2888/IP2Location-C-Library
}

function build_luajit() {
    cd ${BUILD_DIR}/LuaJIT && make clean && rm -rf ${BUILD_DIR}/ngx_lib && mkdir ${BUILD_DIR}/ngx_lib

    make PREFIX=${BUILD_DIR}/LuaJIT && make install PREFIX=${BUILD_DIR}/ngx_lib 
    #&& rm $luajit_lib_path/lib/libluajit-5.1.so*
    if [[ $? -ne 0 ]];then
        echo "build juajit fail"
        exit -1
    fi

    echo "build juajit successfuly"
}


export LUAJIT_LIB=${BUILD_DIR}/ngx_lib/lib
export LUAJIT_INC=${BUILD_DIR}/ngx_lib/include/luajit-2.1

## Patch
function patch() {
	patch -f -p1 -d openssl < nginx-ssl-fingerprint/patches/openssl.1_1_1.patch
	patch -f -p1 -d nginx < nginx-ssl-fingerprint/patches/nginx.patch
}

export LSAN_OPTIONS=verbosity=1:log_threads=1
			#--with-ld-opt="-L${BUILD_DIR}/ngx_lib" \

function build_deps() {
	echo build
}

function build() {
	## Build Nginx
	cd /build/nginx && \
				ASAN_OPTIONS=symbolize=1 ./auto/configure \
				--with-cc-opt='-m32 -march=i386' \
				--with-cc-opt="-fsanitize=address -O -fno-omit-frame-pointer" \
				--with-stream_ssl_module \
				--with-debug --with-stream \
				--with-http_ssl_module \
				--with-http_v2_module \
				--with-openssl=${BUILD_DIR}/openssl \
				--add-module=${BUILD_DIR}/ngx_devel_kit \
				--add-module=${BUILD_DIR}/nginx-ssl-fingerprint \
				--add-module=${BUILD_DIR}/lua-nginx-module \
				--add-module=${BUILD_DIR}/lua-upstream-nginx-module && \
				make
}

build

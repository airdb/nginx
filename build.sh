#!/bin/bash

BUILD_DIR=/build

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


#build_luajit

export LUAJIT_LIB=${BUILD_DIR}/ngx_lib/lib
export LUAJIT_INC=${BUILD_DIR}/ngx_lib/include/luajit-2.1
cd /build/nginx && \
			ASAN_OPTIONS=symbolize=1 ./auto/configure \
			--with-openssl=../openssl \
			--with-http_ssl_module \
			--with-stream_ssl_module \
			--with-debug --with-stream \
			--with-http_v2_module \
			--with-cc-opt="-fsanitize=address -O -fno-omit-frame-pointer" \
			--with-ld-opt="-L/usr/local/lib -Wl,-E -lasan" \
			--with-ld-opt="-L${BUILD_DIR}/ngx_lib" \
			--add-module=${BUILD_DIR}/ngx_devel_kit \
			--add-module=${BUILD_DIR}/nginx-ssl-fingerprint \
			--add-module=${BUILD_DIR}/lua-nginx-module \
			--add-module=${BUILD_DIR}/lua-upstream-nginx-module && \
			make

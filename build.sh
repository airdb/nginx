#!/bin/bash

BUILD_DIR=/build
BUNDLE_DIR=/build/openresty/openresty-1.25.3.1/bundle

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
        #--user=nginx \
        #--group=nginx \
	#--prefix=/usr/sbin/nginx \

## Build Nginx
function build() {
	export LUAJIT_LIB=/usr/loca/lib
	export LUAJIT_INC=/usr/local/include/luajit-2.1


	set -x
	#cd /build/nginx && \
	cd /build/openresty/openresty-1.25.3.1 && \
	ASAN_OPTIONS=symbolize=1 ./configure \
        --prefix=/etc/nginx \
        --sbin-path=/usr/sbin/nginx \
        --modules-path=/usr/lib/nginx/modules \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --pid-path=/var/run/nginx.pid \
        --lock-path=/var/run/nginx.lock \
        --http-client-body-temp-path=/var/cache/nginx/client_temp \
        --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
        --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
        --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
        --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
        --with-perl_modules_path=/usr/lib/perl5/vendor_perl \
        --with-compat \
        --with-file-aio \
        --with-threads \
        --with-http_addition_module \
        --with-http_auth_request_module \
        --with-http_dav_module \
        --with-http_flv_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_mp4_module \
        --with-http_random_index_module \
        --with-http_realip_module \
        --with-http_secure_link_module \
        --with-http_slice_module \
        --with-http_ssl_module \
        --with-http_stub_status_module \
        --with-http_sub_module \
        --with-http_v2_module \
        --with-mail \
        --with-mail_ssl_module \
        --with-stream \
        --with-stream_realip_module \
        --with-stream_ssl_module \
        --with-stream_ssl_preread_module \
	--with-openssl=${BUILD_DIR}/openssl \
	--add-module=${BUNDLE_DIR}/ngx_lua-0.10.26
        #--with-cc-opt='-Os -Wformat -Werror=format-security -g' 
        #--with-ld-opt='-Wl,--as-needed,-O1,--sort-common -Wl,-z,pack-relative-relocs'
		#--add-module=${BUILD_DIR}/ngx_devel_kit \
		#--add-module=${BUILD_DIR}/nginx-ssl-fingerprint \
		#--add-module=${BUILD_DIR}/lua-upstream-nginx-module && \
        #--with-ld-opt='-Wl,--as-needed,-O1,--sort-common -Wl,-z,pack-relative-relocs'
        #--with-http_v3_module \

	make && \
	make install
	set +x
	#cp /build/nginx/objs/nginx /srv/output/
}


build

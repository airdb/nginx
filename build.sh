#!/bin/bash

BUILD_DIR=/build
BUNDLE_DIR=/build/openresty/openresty-1.25.3.1/



OPENSSL_VERSION=OpenSSL_1_1_1-stable
NGINX_VERSION=release-1.23.1

## Patch
function patch_openssl() {
	#git clone -b http2 https://github.com/phuslu/nginx-ssl-fingerprint ${BUILD_DIR}/nginx-ssl-fingerprint
        patch -f -p1 -d /build/openssl < ${BUILD_DIR}/nginx-ssl-fingerprint/patches/openssl.1_1_1.patch
        #patch -f -p1 -d /build/openssl < /build/nginx-ssl-fingerprint/patches/openssl.1_1_1.patch
        patch -f -p1 -d ${BUNDLE_DIR}/bundle/nginx-1.25.3 < ${BUILD_DIR}/nginx-ssl-fingerprint/patches/openresty_1.25.3.1_nginx.patch
}

function build_deps() {
	echo build
}
        #--user=nginx \
        #--group=nginx \
	#--prefix=/usr/sbin/nginx \

## Build Nginx
function build() {
	#export LUAJIT_LIB=/usr/loca/lib
	#export LUAJIT_INC=/usr/local/include/luajit-2.1


	set -x
	#cd /build/nginx && \
	cd ${BUNDLE_DIR}
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
        --add-module=${BUILD_DIR}/nginx-ssl-fingerprint
	#--add-module=${BUNDLE_DIR}/ngx_lua-0.10.26
        #--with-cc-opt='-Os -Wformat -Werror=format-security -g' 
        #--with-ld-opt='-Wl,--as-needed,-O1,--sort-common -Wl,-z,pack-relative-relocs'
		#--add-module=${BUILD_DIR}/ngx_devel_kit \
		#--add-module=${BUILD_DIR}/nginx-ssl-fingerprint \
		#--add-module=${BUILD_DIR}/lua-upstream-nginx-module && \
        #--with-ld-opt='-Wl,--as-needed,-O1,--sort-common -Wl,-z,pack-relative-relocs'
        #--with-http_v3_module \

	make && \
	make install && \
	mkdir -p /var/cache/nginx/client_temp
	set +x
	#cp /build/nginx/objs/nginx /srv/output/
}


patch_openssl
build

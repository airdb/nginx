FROM ubuntu:latest

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && \
	apt-get install -y git make gcc curl zlib1g-dev libpcre3-dev vim wget

WORKDIR /build
ENV BUILD_DIR /build
ENV VERSION 1.21.4.1
ENV NGINXVERSION 1.21.4

RUN wget https://openresty.org/download/openresty-${VERSION}.tar.gz && tar xvf openresty-${VERSION}.tar.gz


WORKDIR  /build/openresty-${VERSION}

RUN cd bundle/ && \
	git clone --depth=1 -b OpenSSL_1_1_1-stable https://github.com/openssl/openssl && 	\
    	git clone --depth=1 -b v0.3.1 https://github.com/vision5/ngx_devel_kit && \
    	git clone --depth=1 -b v0.07 https://github.com/openresty/lua-upstream-nginx-module && \
    	git clone --depth=1 -b v0.62 https://github.com/openresty/echo-nginx-module

RUN pwd && ls && ls && cd bundle/ && \
    	git clone --depth=1 -b dean/fix-issue https://github.com/phuslu/nginx-ssl-fingerprint && \
	patch -p1 -d openssl < nginx-ssl-fingerprint/patches/openssl.1_1_1.patch && \
	patch -p1 -d nginx-${NGINXVERSION} < nginx-ssl-fingerprint/patches/nginx.patch


RUN ./configure -j2 \
	--with-openssl=./bundle/openssl \
	--add-module=./bundle/nginx-ssl-fingerprint
	#--add-module=./bundle/headers-more-nginx-module-0.33

RUN make -j2 && make install

WORKDIR /usr/local/openresty/nginx

EXPOSE 443
EXPOSE 8444

#CMD ./nginx/objs/nginx -p /build -c nginx-ssl-fingerprint/conf/nginx.conf
CMD /usr/local/openresty/bin/openresty -c /usr/local/openresty/nginx/conf/nginx.conf -g  'daemon off;'
#CMD sleep 3600000000

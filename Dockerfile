FROM ubuntu:latest

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && \
	apt-get install -y git make gcc curl zlib1g-dev libpcre3-dev vim wget

WORKDIR /build
ENV BUILD_DIR /build
ENV VERSION 1.21.4.1

RUN wget https://openresty.org/download/openresty-${VERSION}.tar.gz && \
    git clone --depth=1 -b OpenSSL_1_1_1-stable https://github.com/openssl/openssl && \
    git clone --depth=1 -b v0.3.0 https://github.com/phuslu/nginx-ssl-fingerprint && \
    git clone --depth=1 -b v0.3.1 https://github.com/vision5/ngx_devel_kit && \
    git clone --depth=1 -b v0.07 https://github.com/openresty/lua-upstream-nginx-module && \
    git clone --depth=1 -b v0.62 https://github.com/openresty/echo-nginx-module


#RUN cd ${BUILD_DIR}/LuaJIT && \
#	make PREFIX=${BUILD_DIR}/LuaJIT && \
#	make install PREFIX=${BUILD_DIR}/ngx_lib
#RUN make patch && \
#    make build && \
#    mkdir logs

RUN tar xvf openresty-${VERSION}.tar.gz && \
	cd openresty-${VERSION} && \
	./configure -j2 \
		--with-openssl=${BUILD_DIR}/openssl && \
	make -j2 && \


EXPOSE 443
EXPOSE 8444

#CMD ./nginx/objs/nginx -p /build -c nginx-ssl-fingerprint/conf/nginx.conf
CMD sleep 3600

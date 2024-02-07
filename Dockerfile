FROM ubuntu:22.04 as builder

ARG DEBIAN_FRONTEND=noninteractive
# ARG OPENSSL_VERSION=OpenSSL_1_1_1-stable
ARG OPENSSL_VERSION=openssl-3.2
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
#CMD ["nginx", "-g", "daemon off;"]
CMD sleep 3600
#


#FROM airdb/nginx-builder:latest as builder

FROM ubuntu:22.04 as release
RUN apt update && \
    apt install --no-install-recommends -y \
    vim git curl wget \
    ca-certificates && \
    rm -rf /var/cache/apt/archives /var/lib/apt/lists/*

COPY --from=builder /etc/nginx /etc/nginx
#COPY --from=builder /etc/lua /etc/lua
COPY --from=builder /usr/sbin/nginx /usr/bin/nginx
COPY --from=builder /var/log/nginx /var/log/nginx
COPY --from=builder /var/cache/nginx/client_temp /var/cache/nginx/client_temp


COPY lua/resty /etc/lua/resty

WORKDIR /etc/lua/lib/

RUN git clone --depth=1 -b master https://github.com/ledgetech/lua-resty-http  && \
	git clone --depth=1 -b master https://github.com/thibaultcha/lua-resty-jit-uuid && \
        git clone --depth=1 -b master https://github.com/openresty/lua-resty-dns

RUN cp /etc/lua/lib/lua-resty-http/lib/resty/* /etc/nginx/lualib/resty/
RUN cp /etc/lua/lib/lua-resty-jit-uuid/lib/resty/* /etc/nginx/lualib/resty/

CMD ["nginx", "-g", "daemon off;"]

FROM ubuntu:latest

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update
RUN apt-get install -y git make gcc curl wget zlib1g-dev libpcre3-dev vim \
	libssl-dev perl build-essential wget

WORKDIR /build
ENV BUILD_DIR /build
# COPY ./openresty/openresty-1.21.4.1 ${BUILD_DIR}/openresty-1.21.4.1
# COPY ./repos ${BUILD_DIR}/repos
COPY build.sh ${BUILD_DIR}

RUN mv ${BUILD_DIR}/repos/* ${BUILD_DIR}/
RUN mkdir -p logs

RUN bash build.sh

EXPOSE 8443
EXPOSE 8080

# CMD ./nginx/objs/nginx -p /build -c nginx-ssl-fingerprint/conf/nginx.conf
CMD sleep 7200

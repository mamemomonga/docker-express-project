FROM debian:jessie

RUN set -xe && \
	rm /etc/localtime && \
	ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
	echo 'Asia/Tokyo' > /etc/timezone

RUN set -xe && \
	mv /etc/apt/sources.list /etc/apt/sources.list.orig && \
	sed -e 's/httpredir\.debian\.org/ftp.jp.debian.org/g' /etc/apt/sources.list.orig > /etc/apt/sources.list && \
	DEBIAN_FRONTEND=noninteractive apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y curl wget sudo xz-utils && \
	rm -rf /var/lib/apt/lists/* 

RUN set -xe && \
	mkdir -p /usr/local/nodejs && \
	curl https://nodejs.org/dist/v6.10.2/node-v6.10.2-linux-x64.tar.xz | tar Jx -C /usr/local/nodejs --strip-components=1
 
ENV PATH /usr/local/nodejs/bin:$PATH
 
RUN set -xe && \
	npm install express-generator -g

ADD server.sh /server.sh
VOLUME /app
WORKDIR /app
EXPOSE 3000
CMD /server.sh

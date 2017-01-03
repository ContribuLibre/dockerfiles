FROM xataz/alpine:3.5
MAINTAINER xataz <https://github.com/xataz>

ENV GID=991 \
    UID=991 \
    SECRET=0423bab3aea2d87d5eedd9a4e8173618 \
    CONTACT=contact@domain.tld \
    MAX_FILE_SIZE=1000000000 \
    WEBROOT=/ \
    DEFAULT_DELAY=1 \
    MAX_DELAY=0

LABEL description="lufi based on alpine" \
      tags="latest" \
      build_ver="2017010301"

RUN BUILD_DEPS="build-base \
                openssl-dev \
                ca-certificates \
                git \
                tar \
                perl-dev \
                libidn-dev \
                wget" \
    && apk add -U ${BUILD_DEPS} \
                openssl \
                perl \
                libidn \
                perl-crypt-rijndael \
                perl-test-manifest \
                tini \
                su-exec \
    && echo | cpan \
    && cpan install Carton \
    && git clone https://github.com/ContribuLibre/lufi.git /usr/lufi \
    && cd /usr/lufi \
    && rm -rf cpanfile.snapshot \
    && carton install \
    && apk del -y ${BUILD_DEPS} \
    && rm -rf /var/cache/apk/* /root/.cpan* /usr/lufi/local/cache/* /usr/lufi/utilities
    
VOLUME /usr/lufi/files /usr/lufi/data

EXPOSE 8080

ADD startup /usr/local/bin/startup
ADD lufi.conf /usr/lufi/lufi.conf
RUN chmod +x /usr/local/bin/startup

CMD ["/usr/local/bin/startup"]

FROM alpine

ENV DIRVISH_VERSION=1.2.1
ENV PERL_MM_USE_DEFAULT=1

COPY dirvish/installer.sh /tmp/installer.sh
COPY dirvish/master.conf /etc/dirvish/master.conf
COPY docker/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN apk update && \
    apk add --no-cache busybox-suid findutils perl perl-utils openssh-client rsync tzdata && \
    apk add --no-cache --virtual .build-deps expect make && \
    cpan install CPAN && \
    cpan install Getopt::Long POSIX Time::ParseDate Time::Period && \
    wget --no-check-certificate -O /tmp/dirvish.tgz "https://dirvish.org/dirvish-${DIRVISH_VERSION}.tgz" && \
    tar -xzf /tmp/dirvish.tgz -C /tmp && \
    mv /tmp/dirvish-${DIRVISH_VERSION} /tmp/dirvish && \
    /tmp/installer.sh && \
    apk del .build-deps && \
    rm -rf /root/.cache /tmp/* /var/cache/apk/* /var/tmp/*

RUN rm -rf /var/spool/cron/crontabs && \
    mkdir -p /var/spool/cron/crontabs && \
    cat <<EOF > /var/spool/cron/crontabs/root
0 0 * * * { dirvish-runall && dirvish-expire; } >> /var/log/cron/cron.log 2>&1
EOF

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["crond", "-f"]

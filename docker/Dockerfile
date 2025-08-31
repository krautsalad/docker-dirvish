FROM alpine AS build

ARG DIRVISH_VERSION

RUN wget --no-check-certificate -q https://dirvish.org/dirvish-${DIRVISH_VERSION}.tgz && \
    mkdir -p /dirvish && \
    tar -xzf dirvish-${DIRVISH_VERSION}.tgz --strip-components=1 -C /dirvish

FROM alpine

ENV PERL_MM_USE_DEFAULT=1

COPY --from=build /dirvish /tmp/dirvish
COPY dirvish/installer.sh /tmp/installer.sh
COPY dirvish/master.conf /etc/dirvish/master.conf
COPY docker/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN apk update && \
    apk add --no-cache busybox-suid findutils perl perl-utils openssh-client rsync tzdata && \
    apk add --no-cache --virtual .build-deps expect make && \
    cpan install CPAN && \
    cpan install Getopt::Long POSIX Time::ParseDate Time::Period && \
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

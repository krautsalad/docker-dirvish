#!/bin/sh
set -e
mkdir -p /var/log/cron
ln -sf /proc/1/fd/1 /var/log/cron/cron.log
[ -n "$SCHEDULE" ] && sed -ri "s/^([^ ]+ [^ ]+ [^ ]+ [^ ]+ [^ ]+)/${SCHEDULE}/" /var/spool/cron/crontabs/root
[ -n "$TZ" ] && [ -f /usr/share/zoneinfo/"$TZ" ] && { cp /usr/share/zoneinfo/"$TZ" /etc/localtime; echo "$TZ" > /etc/timezone; }
[ -n "$VAULTS" ] && VAULTS_LINES=$(echo "$VAULTS" | tr ',' '\n' | sed -e 's/^[[:space:]]*//' -e 's/^/\t/') && replacement=$(printf "Runall:\n%s" "$VAULTS_LINES") && awk -v r="$replacement" 'BEGIN {skip=0} /^Runall:/ {print r; skip=1; next} /^[^ \t]/ {if (skip) {skip=0}} {if (!skip) print}' /etc/dirvish/master.conf > /etc/dirvish/master.conf.tmp && mv /etc/dirvish/master.conf.tmp /etc/dirvish/master.conf
exec "$@"

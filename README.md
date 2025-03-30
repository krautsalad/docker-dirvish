# docker-dirvish

Cron-Managed Dirvish Disk Backup.

**docker-dirvish** is an Alpine-based Docker container that periodically runs the [dirvish program](https://dirvish.org/) using cron. It provides a convenient way to automate disk backups with Dirvish.

## Configuration

### Docker Compose Example

```yaml
# docker-compose.yml
services:
  dirvish:
    container_name: dirvish
    environment:
      SCHEDULE: 0 3 * * *
      TZ: Europe/Berlin
      VAULTS: >-
        server1.krautsalad.com,
        server2.krautsalad.com
    image: krautsalad/dirvish
    restart: unless-stopped
    volumes:
      - /mnt/vaults:/var/lib/dirvish
      - /root/.ssh:/root/.ssh
```

### Environment Variables

- `SCHEDULE`: Cron schedule for running the backup (default: 0 0 * * *).
- `TZ`: Timezone setting (default: UTC).
- `VAULTS`: Comma-separated list of vault names for Dirvish to manage (default: empty).

## How it works

At runtime, the container's cron job executes two commands in sequence:

1. dirvish-expire: Expires old backups based on your configuration.
2. dirvish-runall: Runs backups for all the configured vaults.

### Initial Setup

Before a vault can be used by Dirvish, you must manually initialize it. For each server you want to back up, create a directory under your vaults directory (e.g. `/mnt/vaults`) with the same name as the server (e.g. `server1.krautsalad.com`). Inside that directory, create a folder named `dirvish`, and within that folder, create a Dirvish configuration file called `default.conf` with content similar to the following:

```
# default.conf
client: server1.krautsalad.com
tree: /
exclude:
  .cache/*
  cache/*
  lost+found/*
  tmp/*
  temp/*
  /dev/shm/*
  /proc/*
  /sys/*
  /var/lib/docker/*
```

After setting up the configuration file, initialize the vault by running:

```
docker exec dirvish dirvish --init --vault=server1.krautsalad.com
```

*Note*: Dirvish connects via SSH using the SSH settings and public keys mounted from your host (in the example, from the root user).

### Dirvish Settings

Dirvish is pre-configured with the following settings:

```
# master.conf
bank:
  /var/lib/dirvish
image-default: %Y%m%d
image-temp: latest
index: bzip2
log: bzip2
rsync-option:
  --human-readable
sparse: true
speed-limit: 2500
summary: long
whole-file: 1
xdev: 0
zxfer: 0
Runall:
expire-default: +14 days
expire-rule:
# Format: min hour dmon month dweek time
# Keep 1 backup of each day for 14 days
  * * * * * +14 days
# Keep 1 backup of each week for 3 months
  * * * * 1 +3 months
```

To override these default settings, set options inside your vault configuration or mount your custom master configuration file at /etc/dirvish/master.conf.

## Source Code

You can find the full source code on [GitHub](https://github.com/krautsalad/docker-dirvish).

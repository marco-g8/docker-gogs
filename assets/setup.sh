#!/bin/bash

set -e

source /RELEASE

# Install Gogs binary
wget --quiet ${DOWNLOAD_URL} -O /tmp/gogs.tar.gz
mkdir /app
mkdir /data
tar xfz /tmp/gogs.tar.gz -C /app
rm /tmp/gogs.tar.gz

# Create links
rm -rf /app/gogs/data /app/gogs/log
ln -s /data/gogs/data /app/gogs/data
ln -s /data/gogs/log /app/gogs/log

# Create git user for Gogs
groupadd -r git
useradd -g git -M -c "Gogs Git User" -d /data/git -s /bin/bash git

# Permisions
chown -R git:git /data

echo "export GOGS_CUSTOM=${GOGS_CUSTOM}" >> /etc/profile

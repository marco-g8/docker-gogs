#!/bin/bash

set -e

source /RELEASE

# Install Gogs binary
wget --quiet ${DOWNLOAD_URL} -O /tmp/gogs.zip
mkdir /app
mkdir /data
unzip -d /app /tmp/gogs.zip > /dev/null
rm /tmp/gogs.zip

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

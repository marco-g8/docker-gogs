#!/bin/bash

create_volume_subfolder() {
  # Create VOLUME subfolder
  for f in /data/gogs/data /data/gogs/conf /data/gogs/log /data/git /data/ssh; do
    if ! test -d $f; then
      mkdir -p $f
    fi
  done
}

init_app_conf() {
  if [ ! -e /data/gogs/conf/app.ini ]; then
    cp /assets/app.ini /data/gogs/conf/app.ini
  fi

  # Set defaults
  sed -i "/^RUN_USER/c\RUN_USER = $USER" /data/gogs/conf/app.ini
  sed -i "/^DISABLE_SSH/c\DISABLE_SSH      = true" /data/gogs/conf/app.ini
  [ ! -z $GOGS_ROOT_URL ] && sed -i "/^ROOT_URL/c\ROOT_URL         = $GOGS_ROOT_URL" /data/gogs/conf/app.ini
}

okd_fixes() {
  # User home not defined
  [ ! -z $HOME ] && export HOME="/data/git"

  # User not found in /etc/passwd
  if [ -z "$(grep /etc/passwd -e "$USER")" ]; then
    export GIT_COMMITTER_NAME="Gogs"
    export GIT_COMMITTER_EMAIL="gogs@fake.local"
  fi 
}

source /etc/profile

create_volume_subfolder
init_app_conf
okd_fixes

# Exec CMD
if [ $# -gt 0 ]; then
    exec "$@"
else
    exec "/app/gogs/gogs web"
fi

#!/bin/bash


if [ $# -ne 1 ] ; then
  echo "Usage: ssh-add-pass keyfile passfile"
  exit 1
fi

set -u     # Stop if an unbound variable is referenced
set -e     # Stop on first error

export HISTIGNORE="expect*";
pass=$SSH_PASS

expect << EOF
  spawn ssh-add $1
  expect "Enter passphrase"
  send "$pass\r"
  expect eof
EOF

export HISTIGNORE="";
pass="";

#save new image on remote server
docker save ${IMAGE_VERTION}.${BUILD_NUMBER} | ssh -C $PUB_HOST docker load

#show active containers
ssh $PUB_HOST docker ps -a

# change docker-compose.yml on remote server
( echo "cat <<EOF" ; cat docker-compose.yml ; echo EOF ) | sh | ssh -C $PUB_HOST "sed -i >> $APP_DIR/docker-compose.yml"

#clean up
ssh-add -D
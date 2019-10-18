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


docker save $PUB_IMAGE | ssh -C $PUB_HOST docker load

ssh $PUB_HOST docker ps -a

#clean up
ssh-add -D
exit
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

#remove previos container versions
ssh $PUB_HOST docker rmi $(ssh $PUB_HOST docker images ${IMAGE_NAME} -q) -f;
#save new image on remote server
docker save ${IMAGE_VERTION}.${BUILD_NUMBER} | ssh -C $PUB_HOST docker load;

# update remote hosts
for i in 0 1
do
	export CURR_NUM=$i;
  dockerCompose=$APP_DIR/host$CURR_NUM/docker-compose.yml;
  # stop host
  ssh $PUB_HOST docker-compose -f $dockerCompose down -v --remove-orphans 
  # change docker-compose.yml on remote server
  ssh $PUB_HOST rm $APP_DIR/host$CURR_NUM/docker-compose.yml
  ( echo "cat <<EOF" ; cat docker-compose.yml ; echo EOF ) | sh | ssh -C $PUB_HOST "cat >> $dockerCompose"
  # start host
  ssh $PUB_HOST docker-compose -f $dockerCompose up -d
done

#clear docker
ssh $PUB_HOST docker system prune -f

#show active containers
ssh $PUB_HOST docker ps -a

#clean up
ssh-add -D
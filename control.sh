#!/bin/bash
set -eu
BASEDIR=$( perl -MCwd -MFile::Basename -e 'print Cwd::abs_path(dirname($ARGV[0]))' $0)

. $BASEDIR/config

show_docker_ps() {
	echo "-----------------------------------------"
	docker ps -a -f "name=$DOCKER_CONTAINER_NAME"
}

echo "-----------------------------------------"
echo "DOCKER Image Name:     $DOCKER_IMAGE_NAME"
echo "DOCKER Container Name: $DOCKER_CONTAINER_NAME"
show_docker_ps
echo "-----------------------------------------"

do_create() {
	docker build --tag $DOCKER_IMAGE_NAME .
	if [ ! -e "$BASEDIR/app" ]; then
		mkdir -p $BASEDIR/app
		docker run \
			-v $BASEDIR/app:/app \
			-it --rm \
			$DOCKER_IMAGE_NAME \
			bash -c 'cd /app && express --view=ejs . && npm install'
	fi
	docker run \
		-p 3000:3000 \
		-v $BASEDIR/app:/app \
		--name $DOCKER_CONTAINER_NAME \
		-e 'DEBUG=app:*' \
		-d \
		$DOCKER_IMAGE_NAME
	exec docker logs -f $DOCKER_CONTAINER_NAME
}

do_destroy() {
	docker stop $DOCKER_CONTAINER_NAME
	docker rm $DOCKER_CONTAINER_NAME
	show_docker_ps
}

do_start() {
	docker start $DOCKER_CONTAINER_NAME
	exec docker logs -f $DOCKER_CONTAINER_NAME
}

do_stop() {
	docker stop $DOCKER_CONTAINER_NAME
	show_docker_ps
}

do_restart() {
	do_stop
	do_start
}

do_shell() {
	exec docker exec -it $DOCKER_CONTAINER_NAME bash
}


usage() {
	echo "USAGE: $0 COMMAND"
	echo "COMMANDS:"
	echo "   [ create | destroy ]"
	echo "   [ start | stop | restart ]"
	echo "   shell"
	exit 1
}

case "${1:-}" in
	"create"  ) do_create  ;;
	"destroy" ) do_destroy ;;
	"stop"    ) do_stop    ;;
	"start"   ) do_start   ;;
	"restart" ) do_restart ;;
	"shell"   ) do_shell   ;;
	*         ) usage ;;
esac



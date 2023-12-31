#!/bin/bash

# Runs a development container of the Playback Distributor module.
#
# Intended for local container development mainly.
#
# NOTE: Should be run from project root ideally.
#
# Usage:
#
# ./playback-distributor/docker/run-dev.sh [... extra args to pass to docker run command]
#

ANESOWA_ROOT=$(echo $(realpath $0) | sed 's|/playback-distributor.*||')

ENTRYPOINT="$1"

if [ "$(uname)" == "Linux" ]; then
	extra_flags=--add-host=host.docker.internal:host-gateway
else
	extra_flags=""
fi

entrypoint=""
if [ "$ENTRYPOINT" ]; then
	entrypoint="--entrypoint $ENTRYPOINT"
fi

set -x # Print commands as they run.

docker run \
	--rm \
	--tty \
	--interactive \
	--volume $ANESOWA_ROOT/playback-distributor/src:/anesowa/playback-distributor/src \
	--volume $ANESOWA_ROOT/playback-distributor/CMakeLists.txt:/anesowa/playback-distributor/CMakeLists.txt \
	--volume $ANESOWA_ROOT/playback-distributor/tests:/anesowa/playback-distributor/tests \
	--volume $ANESOWA_ROOT/lib/c/commons/CMakeLists.txt:/anesowa/lib/c/commons/CMakeLists.txt \
	--volume $ANESOWA_ROOT/recordings:/anesowa/recordings:ro \
	$extra_flags \
	$entrypoint \
	anesowa/playback-distributor:dev

set +x

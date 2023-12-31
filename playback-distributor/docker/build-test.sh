#!/bin/bash

# Builds an image of the Playback Distributor module to run the tests.
#
# NOTE: Should be run from project root ideally.
#
# Usage:
#
# ./playback-distributor/docker/build-test.sh [... extra args to pass to docker build command]
#

ANESOWA_ROOT=$(echo $(realpath $0) | sed 's|/playback-distributor.*||')

set -x # Print commands as they run.

docker build \
	--build-arg DEBUG=0 \
	--tag anesowa/playback-distributor:test \
	--file $ANESOWA_ROOT/playback-distributor/Dockerfile \
	--target test \
	$(echo $@) \
	$ANESOWA_ROOT

set +x

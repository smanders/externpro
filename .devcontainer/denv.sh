#!/usr/bin/env bash
cd "$( dirname "$0" )"
pushd .. > /dev/null
rel=$(grep FROM .devcontainer/Dockerfile | cut -d- -f2)
rel=${rel//:}
rel=bp${rel/./-}
env="COMPOSE_PROJECT_NAME=${PWD##*/}"
env="${env}\nHNAME=${rel}"
env="${env}\nUSERID=$(id -u ${USER})"
env="${env}\nGROUPID=$(id -g ${USER})"
echo -e "${env}" > .env
popd > /dev/null

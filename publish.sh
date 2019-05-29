#!/usr/bin/env bash

readlink_bin="${READLINK_PATH:-readlink}"
if ! "${readlink_bin}" -f test &> /dev/null; then
  __DIR__="$(dirname "$(python -c "import os,sys; print(os.path.realpath(os.path.expanduser(sys.argv[1])))" "${0}")")"
else
  __DIR__="$(dirname "$("${readlink_bin}" -f "${0}")")"
fi

source "${__DIR__}/.bash/functions.lib.sh"

set -E
trap 'throw_exception' ERR

if [[ -z "${REPO_NAME}" ]]; then
  consolelog "REPO_NAME not set" "error"
  exit 1
fi

if [[ "${GIT_BRANCH}" == "master" ]]; then
  tag="latest"
elif [[ ! -z "${CHANGE_ID}" ]]; then
  tag="pr-${CHANGE_ID}"
else
  tag="dev"
fi

docker tag "${REPO_NAME}" "348539006591.dkr.ecr.eu-west-1.amazonaws.com/${REPO_NAME}:${tag}"
docker push "348539006591.dkr.ecr.eu-west-1.amazonaws.com/${REPO_NAME}:${tag}"

if [[ ! -z "${GIT_COMMIT}" ]]; then
  docker tag "${REPO_NAME}" "348539006591.dkr.ecr.eu-west-1.amazonaws.com/${REPO_NAME}:${GIT_COMMIT}"
  docker push "348539006591.dkr.ecr.eu-west-1.amazonaws.com/${REPO_NAME}:${GIT_COMMIT}"
fi

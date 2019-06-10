#!/usr/bin/env bash

readlink_bin="${READLINK_PATH:-readlink}"
if ! "${readlink_bin}" -f test &> /dev/null; then
  __DIR__="$(dirname "$(python -c "import os,sys; print(os.path.realpath(os.path.expanduser(sys.argv[1])))" "${0}")")"
else
  __DIR__="$(dirname "$("${readlink_bin}" -f "${0}")")"
fi

source "${__DIR__}/.bash/functions.lib.sh"
source "${__DIR__}/.bash/name.lib.sh"

set -E
trap 'throw_exception' ERR

extra_args=()

if docker pull "135132174985.dkr.ecr.eu-west-1.amazonaws.com/${REPO_NAME}:latest"; then
  extra_args+=( "--cache-from" )
  extra_args+=( "135132174985.dkr.ecr.eu-west-1.amazonaws.com/${REPO_NAME}:latest" )
fi

docker build \
  -t "${REPO_NAME}" \
  "${extra_args[@]}" \
  .

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

extra_args=()

docker build \
  -t "${REPO_NAME}" \
  "${extra_args[@]}" \
  .

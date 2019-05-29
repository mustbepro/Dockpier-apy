throw_exception() {
  consolelog "Ooops!" "error"
  echo 'Stack trace:' 1>&2
  while caller $((n++)) 1>&2; do :; done;
  exit 1
}

consolelog() {
  local color
  local ts

  # el-cheapo way to detect if timestamp prefix needed
  if [[ ! -z "${JENKINS_HOME}" ]]; then
    ts=''
  else
    ts="[$(date -u +'%Y-%m-%d %H:%M:%S')] "
  fi

  color_reset='\e[0m'

  case "${2}" in
    success )
      color='\e[0;32m'
      ;;
    error )
      color='\e[1;31m'
      ;;
    * )
      color='\e[0;37m'
      ;;
  esac

  if [[ ! -z "${1}" ]] && [[ ! -z "${2}" ]] && [[ "${2}" = "error" ]]; then
    printf "${color}%s%s: %s${color_reset}\n" "${ts}" "${0##*/}" "${1}" >&2
  elif [[ ! -z "${1}" ]]; then
    printf "${color}%s%s: %s${color_reset}\n" "${ts}" "${0##*/}" "${1}"
  fi

  return 0
}

echo_helper() {
  if [[ $# -ne 2 ]]; then
    echo "$0 takes exactly 2 arguments!"
    return 1
  fi

  local RED="\033[31m"
  local GREEN="\033[32m"
  local YELLOW="\033[33m"
  local BOLD="\033[1m"
  local RESET="\033[0m"

  local message_type="$1"
  local message="$2"

  case "$message_type" in
  "success")
    echo -e "${BOLD}${GREEN}${message}${RESET}"
    ;;
  "warning")
    echo -e "${YELLOW}${message}${RESET}"
    ;;
  "error")
    echo -e "${BOLD}${RED}${message}${RESET}"
    ;;
  *)
    echo -e "${BOLD}${RED}Invalid message type: '$message_type'! Valid message types are: success, warning, error.${RESET}"
    return 1
    ;;
  esac

  return 0
}

echo_success() {
  if [[ $# -ne 1 ]]; then
    echo "$0 takes exactly 1 argument!"
    return 1
  fi

  local message="$1"

  echo_helper success "$message"
}

echo_warning() {
  if [[ $# -ne 1 ]]; then
    echo "$0 takes exactly 1 argument!"
    return 1
  fi

  local message="$1"

  echo_helper warning "$message"
}

echo_error() {
  if [[ $# -ne 1 ]]; then
    echo "$0 takes exactly 1 argument!"
    return 1
  fi

  local message="$1"

  echo_helper error "$message"
}

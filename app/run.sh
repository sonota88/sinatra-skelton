#!/bin/bash

echo_rbenv_root(){
  if   [ -d "${HOME}/.rbenv" ]; then
    echo "${HOME}/.rbenv"
  elif [ -d "${HOME}/.anyenv/envs/rbenv" ]; then
    echo "${HOME}/.anyenv/envs/rbenv"
  else
    echo "RBENV_ROOT not found" >&2
    exit 1
  fi
}

cmd_up(){
  local port=$1

  export RBENV_ROOT="$(echo_rbenv_root)"
  export PATH="${RBENV_ROOT}/bin:${PATH}"
  eval "$(rbenv init -)"

  BUNDLE_GEMFILE="../Gemfile"

  bundle exec rackup -p $port -o 0.0.0.0
}

cmd_down(){
  local port=$1

  curl http://localhost:${port}/shutdown
}

cmd="$1"; shift
case $cmd in
  up)
    cmd_up "$@"
    ;;
  down)
    cmd_down "$@"
    ;;
  *)
    echo "invalid command" >&2
    exit 1
    ;;
esac

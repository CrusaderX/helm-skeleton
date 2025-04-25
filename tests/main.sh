#!/usr/bin/env bash

. $(dirname -- "$( readlink -f -- "$0"; )")/_helpers.sh
. $(dirname -- "$( readlink -f -- "$0"; )")/src.sh

function main() {
  args "$@"

  configure
  find_charts
  build_dependencies
  find_values_files
  run
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi

#!/usr/bin/env bash

set -eo pipefail

charts_root="examples/charts"
values_root="examples/values"
schema="https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json"
debug=false
namespace=""
validators=()

declare -a tasks=()

function args() {
  longOpts="help,version,debug,validators::,namespace::"
  args=$(getopt -o hvdf::n:: --long ${longOpts} -- "$@")

  while true; do
    case "$1" in
      -h|--help) usage; exit 0;;
      -d|--debug) debug=true; shift;;
      -n|--namespace) namespace="$2"; shift 2;;
      --validators) IFS=',' read -ra validators <<< "$2"; shift 2;;
      --) shift; break;;
      *) break ;;
    esac
  done

  if [[ -z "$namespace" || ${#validators[@]} -eq 0 ]]; then
    echo "Namespace and validators are required."
    usage
  fi
}

function configure() {
  if [[ "$debug" == true ]]; then
    set -x
  fi
}

function find_charts() {
  INFO "Finding charts in $charts_root"

  mapfile -t charts < <(find "$charts_root" -type f -name Chart.yaml -exec dirname {} \;)
}

function build_dependencies() {
  INFO "Updating dependencies"

  echo ${charts[@]} | xargs -t -P5 -n1 helm dep update --skip-refresh &>/dev/null
}

function find_values_files() {
  INFO "Finding values files in $values_root"

  for chart_path in "${charts[@]}"; do
    chart_name=$(basename "$chart_path")
    values_file="$values_root/${chart_path#$charts_root/}/$namespace.yaml"
    if [[ -f "$values_file" ]]; then
      tasks+=("$chart_path|$values_file")
    else
      WARNING "Warning: No values file found for chart '$chart_name' in namespace '$namespace'. Skipping."
    fi
  done
}

function run_validators() {
  local chart="$1"
  local values="$2"

  INFO "Validating chart $(basename "$chart") with values file $values"
  output=$(helm template "$chart" --values "$values" --skip-tests)

  for validator in "${validators[@]}"; do
    case "$validator" in
      kubeconform)
        echo "$output" | kconform -strict -summary -exit-on-error -schema-location default -schema-location ${schema} ;;
      kubeval)
        echo "$output" | kubeval --strict ;;
      *)
        WARNING "Validator '$validator' is not supported."
    esac
  done
}

function run() {
  for task in "${tasks[@]}"; do
    IFS='|' read -r chart values <<< "$task"
    run_validators "$chart" "$values"
  done
}

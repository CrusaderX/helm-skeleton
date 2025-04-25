KNRM="\x1B[0m"
KGRN="\x1B[32m"
KYEL="\x1B[33m"
KLBLU="\x1B[94m"

function version() {
    programName=${0##*/}
    programVersion='0.0.1'
    echo ${programName} version: ${programVersion}

    exit 0
}

function usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS] [--validators <tool1,tool2,...>]

Options:
  -h, --help           Show this help message and exit
  -n, --namespace      Namespace to select corresponding values files
  -d, --debug          Enable debug output
  --validators         Comma-separated list of validators (e.g., kubeconform,kubeval)

Example:
  $(basename "$0") --namespace development --validators kubeconform,kubeval
EOF
  exit 0
}

function INFO() {
    printf $KLBLU"[INFO]: "$KNRM
    printf "%s " "$@"
    printf "\n"
}

function WARNING() {
    printf $KYEL"[Warning]: "$KNRM
    printf "%s " "$@"
    printf "\n"
}

function call() { ($1) ;}

function assertEqual() {
    if [[ "$1" != "$2" ]]; then
        WARNING "Expected: $2"
        WARNING "Got: $1"
    fi
}

function assertNotEqual() {
    if [[ "$1" == "$2" ]]; then
        WARNING "Expected: $1 != $2"
        WARNING "Got: $1 == $2"
    fi
}

function assertRegex() {
    if [[ ! "$1" =~ "$2" ]]; then
        WARNING "Expected: $2"
        WARNING "Got: $1"
    fi
}

function assertNotEmpty() {
    if [[ -z "$1" ]]; then
        WARNING "Expected: Not empty"
        WARNING "Got: $1"
    fi
}

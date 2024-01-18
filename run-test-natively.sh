#!/usr/bin/env bash
#
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
workflow=${1:-$SCRIPT_DIR/test-workflow.txt}

declare -a steps
IFS=$'\n' steps=($(cat "$workflow"))
ocrd process "${steps[@]}"

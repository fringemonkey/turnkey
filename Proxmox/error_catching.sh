#!/bin/bash

set -e
trap 'echo -e "\033[31mError: Command failed at line $LINENO\033[0m"' ERR

function progress_bar() {
    local total=$1
    local current=$2
    local width=50

    local percent=$((current * 100 / total))
    local completed_width=$((current * width / total))
    local remaining_width=$((width - completed_width))

    echo -ne "\r["
    printf "%0.s#" $(seq 1 $completed_width)
    printf "%0.s " $(seq 1 $remaining_width)
    echo -ne "] $percent% "
}

TOTAL_STEPS=8

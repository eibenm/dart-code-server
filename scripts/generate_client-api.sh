#!/usr/bin/env bash

set -o errexit # causes script to exit immediately when a command fails
set -o pipefail # causes pipe to fail if any command in the pipeline fails

# Whitelist of acceptable Dart versions
dartversions=( '2.1.0' )

# Message colors
red='\033[0;31m'
burntYellow='\033[0;33m'
nocolor='\033[0m'

function errcolorecho() {
    echo $red"$@"$nocolor
}

function infocolorecho() {
    echo $burntYellow"$@"$nocolor
}

function checkDart() {
    infocolorecho 'Checking Dart...'
    missing=0; dartInstalled=`which dart` || missing=1
    if [[ $missing -eq 0 ]]; then
        version=`dart --version 2>&1`
        for dartversion in ${dartversions[@]}; do
            if [[ $version == *$dartversion* ]]; then
                which dart
                dart --version
                infocolorecho 'Checking Dart...done'
                return
            fi
        done
    fi

    # Dart setups vary significantly by developer, so let the user set up as they see fit
    errcolorecho 'Compatible Dart version was not found.'
    errcolorecho "Please install Dart (one of these versions: ${dartversions[@]}) and rerun this script."
    exit 1
}

# Ensure correct Dart version
checkDart

# Generate discovery document
pub run rpc:generate discovery -i lib/src/api_server.dart > generated/dartservices.json

# Generate client stub library
pub run discoveryapis_generator:generate files -i generated -o generated

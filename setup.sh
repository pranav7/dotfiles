#!/usr/bin/env bash

set -eou pipefail

setup () {
  readonly DIR="$(dirname "$0")"

  . "${DIR}/shell/functions.sh"
  . "${DIR}/os/all.sh"

  # Determine which OS we are in and follow the corresponding script
  case $OSTYPE in
    darwin*) 
      print_header "Detected macOS"
      . "${DIR}/os/macos.sh" 
      ;;
    msys*|cygwin*) 
      print_header "Detected Windows"
      . "${DIR}/os/windows.sh" 
      ;;
    linux*) 
      print_header "Detected Linux"
      . "${DIR}/os/linux.sh" 
      ;;
    *) 
      print_header "Unknown OS: $OSTYPE"
      echo "Unsupported operating system: $OSTYPE"
      echo "Supported: darwin (macOS), linux, msys/cygwin (Windows)" 
      exit 1
      ;;
  esac
}

setup
#!/usr/bin/env bash

set -eou pipefail

setup () {
  readonly DIR="$(dirname "$0")"

  . "${DIR}/shell/functions.sh"
  . "${DIR}/os/all.sh"

  # Determine which OS we are in and follow the corresponding script
  case $OSTYPE in
    darwin*) . "${DIR}/os/macos.sh" ;;
      msys*) . "${DIR}/os/windows.sh" ;;
     linux*) . "${DIR}/os/linux.sh" ;;
          *) 
            echo "Unsupported OS: $OSTYPE"
            echo "Supported: darwin (macOS), linux, msys (Windows)" 
            exit 1
            ;;
  esac
}

setup
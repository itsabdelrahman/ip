#!/usr/bin/env bash

version="1.0.0"

# Verbose by default
if [ -t 1 ]; then
  verbose=1
else
  verbose=
fi

# Usage information
usage() {
  cat <<EOF

  Usage: ip [options]

  Options:
    -q, --quiet      only output results
    -V, --version    output version number
    -h, --help       output usage information

EOF
}

# Parse options
while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do
  case $1 in
    -V | --version )
      echo $version
      exit
      ;;
    -q | --quiet )
      verbose=
      ;;
    -h | --help )
      usage
      exit
      ;;
  esac
  shift
done
if [[ "$1" == "--" ]]; then shift; fi

# Check operating system
if [ "$(uname)" == "Darwin" ]; then
  macOS=1
  linux=
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  macOS=
  linux=1
else
  echo -e "\033[91m ✗ Unsupported operating system! \033[0m"
  exit 1
fi

# Check internet connectivity
if ! ping -c 1 google.com >> /dev/null 2>&1; then
  echo -e "\033[91m ✗ You're offline! \033[0m"
  exit 1
fi

# Print loading message
if [ $verbose ]; then
  echo ""
  echo -e "\033[90m Getting internal & external IP addresses… \033[0m"
  echo ""
fi

if [ $macOS ]; then
  internal=$(ifconfig | grep "inet " | grep -Fv 127.0.0.1 | awk '{print $2}')
elif [ $linux ]; then
  internal=$(hostname -I)
fi

external=$(dig +short myip.opendns.com @resolver1.opendns.com)

# Print results
if [ $verbose ]; then
  echo -e "\033[96m ✓ Internal IP: $internal \033[0m"
  echo -e "\033[96m ✓ External IP: $external \033[0m"
else
  echo $internal
  echo $external
fi

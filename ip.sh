#!/usr/bin/env sh

version="0.1.0"

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

# Print waiting message
if [ $verbose ]; then
  echo ""
  echo "\033[90m Getting internal & external IPs… \033[39m"
  echo ""
fi

internal=$(ifconfig | grep "inet " | grep -Fv 127.0.0.1 | awk '{print $2}')
external=$(dig +short myip.opendns.com @resolver1.opendns.com)

# Print results
if [ $verbose ]; then
  echo "\033[96m ✓ Internal IP: $internal \033[39m"
  echo "\033[96m ✓ External IP: $external \033[39m"
else
  echo $internal
  echo $external
fi

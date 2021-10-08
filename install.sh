#!/bin/bash

usage_string="usage: ./$(basename "$0") [OPTIONS]

Options
  --help, -h	Show this message and exit
  --dir		Directory to place executables
		(default: /usr/local/bin)

Examples
  ./$(basename "$0")
  ./$(basename "$0") --dir /bin
"

usage() { echo -n "$usage_string" 1>&2; }

set -e
set -u
set -o pipefail

TORNODES=./tornodes
ISTOR=./istor
BINDIR=/usr/local/sbin

while [[ $# -gt 0 ]]
do
	arg="$1"
	case $arg in
		--dir|-d)
			BINIR="$2"
			shift
			shift
			;;
		-h|--help)
			usage
			exit 0
			;;

		*)
			echo "[-] Invalid argument: $arg"
			usage
			exit 1
			;;
	esac
done

chmod +x $TORNODES $ISTOR
cp $TORNODES "$BINDIR/$TORNODES"
cp $ISTOR "$BINDIR/$ISTOR"

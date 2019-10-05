#!/bin/sh

set -e
#set -x

MIN_MATRIX_SIZE="4"

while test "$#" -gt 0; do
  case "$1" in
  -h) #|--help)
    printf "Options:"
    printf "\n     -h, --help           Shows help"
    printf "\n     -i, --input          Input file"
    printf "\n     -m, --matrix-size    Matrix dimension"
    printf "\n"
    exit 0
    ;;
  -m* | --matrix-size*)
    shift
    MATRIX_SIZE=$1
    shift
    ;;
  -i* | --input*)
    shift
    INPUT_FILE=$1
    printf "\nFile used is '%s'\n" "$1"
    shift
    ;;
  esac
done

if [ -z "$INPUT_FILE" ]; then
  printf "\nNo input file. Try [ -h / --help ]\n\n"
  exit 1
fi

SECONDS="$(ffprobe "$INPUT_FILE" -show_entries format=duration -v quiet -of csv="p=0")"
TIME="${SECONDS%.*}" # get total runtime in seconds

if [ -n "$MATRIX_SIZE" ]; then
  SECONDS=$(($TIME / $MATRIX_SIZE))
  MINUTES$(($SECONDS / 60))
else
  SECONDS=$(($TIME / $MIN_MATRIX_SIZE))
  MINUTES=$(($SECONDS / 60 - 1))
fi

printf "\nTime in seconds is %s\n" "$SECONDS"
printf "\nTime in minutes, rounded down is %s\n" "$MINUTES" 

while true; do
  printf "\nNo collage size specified, fallback on default 2x2? [yY/nN]\n"
  IFS= read -r result || exit
  case $result in
    ([yY])
    MIN_MATRIX_SIZE="4"
    break
  esac
  printf "\nTry [ -h / --help ]\n"
  exit 1
done

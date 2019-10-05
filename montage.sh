#!/bin/sh

set -e
set -u

MATRIX_SIZE="9"
MIN_MATRIX_SIZE="4"

while getopts "m:i:" o; do
  case "${o}" in
    m)
      MATRIX_SIZE="$OPTARG"
      ;;
    i)
      INPUT=${OPTARG}
      echo "input is $OPTARG"
      ;;
    *)
      usage
      ;;
  esac
done
shift "$(($OPTIND -1))"


printf "\nFile used is '%s'\n" "$INPUT"
SECONDS="$(ffprobe "$INPUT" -show_entries format=duration -v quiet -of csv="p=0")"
TIME="${SECONDS%.*}" # get total runtime in seconds
SPLIT=$(( $TIME / $MATRIX_SIZE )) # 

printf "\nTime in seconds is %s\n" "$TIME"
printf "\nWith a collage of %s, a screenshot is taken every %s seconds\n\n" "$MATRIX_SIZE" "$SPLIT"
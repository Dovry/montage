#!/bin/sh

set -e
#set -u

MIN_MATRIX_SIZE="4"

while getopts "m:i:" o; do
  case "${o}" in
    m)
      MATRIX_SIZE="$OPTARG"
      ;;
    i)
      INPUT=${OPTARG}
      printf "\nFile used is '%s'\n" "$INPUT"
      ;;
    *)
      printf ""
      ;;
  esac
done
shift "$(($OPTIND -1))"


SECONDS="$(ffprobe "$INPUT" -show_entries format=duration -v quiet -of csv="p=0")"
TIME="${SECONDS%.*}" # get total runtime in seconds

if [ -n "$MATRIX_SIZE" ]; then
  SPLIT=$(( $TIME / $MATRIX_SIZE )) # 
else
  SPLIT=$(( $TIME / $MIN_MATRIX_SIZE )) # 
fi

printf "\nTime in seconds is %s\n" "$TIME"

if [ -n "$MATRIX_SIZE" ]; then
  printf "\nWith a collage of %s, a screenshot is taken every %s seconds\n\n" "$MATRIX_SIZE" "$SPLIT"
else
  printf "\nWith a collage of %s, a screenshot is taken every %s seconds\n\n" "$MIN_MATRIX_SIZE" "$SPLIT"
fi
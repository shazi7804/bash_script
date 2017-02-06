#!/bin/bash
#
# Program: Calculates the number of address visits for the log
# Author: shazi
# github: https://github.com/shazi7804

DefaultYear=$(date +%Y)

helpmsg() {
  echo "Usage $0 [File] [OPTION]"
  echo ""
  echo "OPTION:"
  echo "  -t        select time range [10:00-18:00]"
  echo "Example:"
  echo "  $ $0 access.log"
  echo "  $ $0 access.log -t 10:00-18:00"
  echo ""
}

hit(){
  if [ -z $min_time ] && [ -z $max_time ]; then
    cat $Log_file | awk '{print $1}' | sort -n | uniq -c | sort -nr | more
  elif [ -z $min_time ] && [ -n $max_time ]; then
    echo "[${0}][Warning]: time format fail. param \"max_time\" not found."
    exit 1
  else
    sed -n '/${DefaultYear}:${min_time}/,/${DefaultYear}:${max_time}/p' $Log_file | awk '{print $1}' | sort -n | uniq -c | sort -nr | more
  fi
}

Log_file=$1
shift
if [ ! -z $Log_file ];then
  if [ ! -f $Log_file ]; then
    echo "[${0}][Warning]: first param need \"log\" file type."
    exit 1
  fi
else
  helpmsg
  exit 1
fi

if [ $# -ge 1 ];then
  for opt in $1
  do
    case $opt in
      -t)
        shift
        timerange=$1
        shift
        min_time=$(echo $timerange | awk -F- '{print $1}')
        max_time=$(echo $timerange | awk -F- '{print $2}')
        hit
        ;;
    esac
  done
else
  hit
fi
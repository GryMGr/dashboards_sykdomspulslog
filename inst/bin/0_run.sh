#!/bin/bash

COMPUTER=$(cat /tmp/computer)

(
  flock -n 200 || exit 1

  source /etc/environment

  echo
  echo
  echo
  echo
  echo "****START****sykdomspulslog****"

  if [ "$COMPUTER" == "smhb" ] ; then
    echo "`date +%Y-%m-%d` `date +%H:%M:%S`/$COMPUTER/BASH/sykdomspulslog GRAB DATA"
    ncftpget -R -v -u "sykdomspulsen.fhi.no|data" -p $SYKDOMSPULS_PROD sykdomspulsen.fhi.no /data_raw/sykdomspulslog/ /data/log/*
  fi

  /usr/local/bin/Rscript /r/sykdomspulslog/src/RunProcess.R

  echo "****END****sykdomspulslog****"
  
) 200>/var/lock/.sykdomspulslog.exclusivelock

#!/bin/bash

# iplist generate
# echo 172.30.{1..254}.{1..254}

IPLIST=($(cat iplist.txt))
TLS_VER=(TLSv1.0 TLSv1.1 TLSv1.2)
SCAN_PORT="443"
NMAP_OPS="--host-timeout 3000ms --max-rtt-timeout 3000ms --script ssl-enum-ciphers -p ${SCAN_PORT}"
OUTPUT="output.csv"

for (( i = 0; i < ${#IPLIST[@]}; i++ )); do
  SUP_TLS=$(nmap $NMAP_OPS ${IPLIST[i]} | egrep "${TLS_VER[0]}|${TLS_VER[1]}|${TLS_VER[2]}" | cut -c 5-11)
  
  if [[ ! -z $SUP_TLS ]]; then
    echo -ne "\n${IPLIST[i]}" >> $OUTPUT

    for (( j = 0; j < ${#SUP_TLS[@]}; j++ )); do
      echo -n ",${SUP_TLS[@]}" >> $OUTPUT
    done
  fi

  unset SUP_TLS
done

#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Użycie: \$0 <adres_URL> <op5stage>"
    exit 1
fi

URL="http://$1/api/v2/alerts?silenced=false&inhibited=false&active=true"
OP5STAGE="$2"

data=$(curl -s --max-time 10 "$URL")

if echo "$data" | grep -q "\"op5stage\":\"$OP5STAGE\""; then
    if echo "$data" | grep -q severity:critical; then
        echo "2" > output.txt && exit 2
    elif echo "$data" | grep -q severity:warning; then
        echo "1" > output.txt && exit 1
    else
        echo "0" > output.txt && exit 0
    fi
else
    echo "0" > output.txt && exit 0
fi

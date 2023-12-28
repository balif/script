#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Użycie: $0 <adres_URL> <op5stage>"
    exit 1
fi

URL="http://$1/api/v2/alerts?silenced=false&inhibited=false&active=true"
OP5STAGE="$2"

echo "URL: $URL"
echo "OP5STAGE: $OP5STAGE"

data=$(curl -s --max-time 10 "$URL")

echo "Data from API: $data"

if echo "$data" | grep -q "\"op5stage\":\"$OP5STAGE\""; then
    if echo "$data" | grep -q '"severity":"critical"'; then
        echo "Severity: 2"
        exit 2
    elif echo "$data" | grep -q '"severity":"warning"'; then
        echo "Severity: 1"
        exit 1
    else
        echo "Severity: 0"
        exit 0
    fi
else
    echo "Op5stage not found, default severity: 0"
    exit 0
fi

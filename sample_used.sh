#!/bin/bash
if [ -z "$1" ]
  then
    echo "No search word supplied"
    exit 1
fi
for i in SONGS/*.XML; do cat $i | tail -n +3 | xmllint --nowarning --xpath "//fileName" - | grep -q "$1" && echo $i ; done 2>/dev/null

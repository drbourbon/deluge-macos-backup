#!/bin/bash
for j in SAMPLES/Imported/* ; do echo $j ; for i in SONGS/*.XML; do cat $i | tail -n +3 | xmllint --nowarning --xpath "//fileName" - | grep -q "$j" && echo -e "\t\t$i" ; done ; done 2>/dev/null

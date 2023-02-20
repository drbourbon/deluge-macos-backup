#!/bin/bash
BACKUP_SCRIPT=./rsync_tmbackup.sh 
INCLUDE_FILE=/tmp/deluge_include.txt
SD_PATH=../../..
#SD_PATH=.
SD_NAME=$(basename "$(cd ../../.. ; pwd)")
BACKUP_PATH=~/Documents/Deluge-Backup/${SD_NAME// /_}

#echo $BACKUP_PATH
#exit

# Adds XML files themselves
find $SD_PATH -name "*.XML" > $INCLUDE_FILE

# Adds samples referenced in some XML file
find $SD_PATH -name "*.XML" -exec cat {} + | sed -ne '/fileName/{s/.*<fileName>\(.*\)<\/fileName>.*/\1/p;}' | sort -u | tail -n +2 >> $INCLUDE_FILE
find $SD_PATH -name "*.XML" -exec cat {} + | sed -ne '/filePath/{s/.*filePath="\(.*\)".*/\1/p;}' | sort -u | tail -n +2 >> $INCLUDE_FILE
find $SD_PATH -name "*.XML" -exec cat {} + | sed -ne '/fileName/{s/.*fileName="\(.*\)".*/\1/p;}' | sort -u | tail -n +2 >> $INCLUDE_FILE

# Adds all samples from downmix fixed folder
find $SD_PATH/SAMPLES/RESAMPLE -name "*.WAV" >> $INCLUDE_FILE

#echo "PROGRESS:0"
mkdir -p "$BACKUP_PATH"
touch "$BACKUP_PATH/backup.marker"

#echo "PROGRESS:10"
$BACKUP_SCRIPT --rsync-append-flags "--files-from=$INCLUDE_FILE" "$SD_PATH" "$BACKUP_PATH"

#echo "PROGRESS:90"
ls -lR "$SD_PATH/SAMPLES/" > "$BACKUP_PATH/sample_ls.txt"

echo $BACKUP_PATH
echo "NOTIFICATION:Deluge backup completed"
echo "done!"


#!/bin/bash
#BACKUP_PATH=~/Documents/Deluge-Backup
BACKUP_SCRIPT=./rsync_tmbackup.sh 
INCLUDE_FILE=/tmp/deluge_include.txt
SD_PATH=../../..
#SD_PATH=.
SD_NAME=$(basename "$(cd ../../.. ; pwd)")
BACKUP_PATH=~/Documents/Deluge-Backup/${SD_NAME// /_}

#echo $BACKUP_PATH
#exit

#echo -e "+ SONGS/*.XML\n+ KITS/*.XML\n+ SYNTHS/*.XML\n+ SAMPLES/RESAMPLE/*.WAV" > $INCLUDE_FILE
#cat $SD_PATH/SONGS/*.XML $SD_PATH/KITS/*.XML $SD_PATH/SYNTHS/*.XML | sed -ne '/fileName/{s/.*<fileName>\(.*\)<\/fileName>.*/+ \1/p;}' | sort -u | tail -n +2 >> $INCLUDE_FILE
#echo "- *" >> $INCLUDE_FILE

find $SD_PATH -name "*.XML" > $INCLUDE_FILE
cat $SD_PATH/SONGS/*.XML $SD_PATH/KITS/*.XML $SD_PATH/SYNTHS/*.XML | sed -ne '/fileName/{s/.*<fileName>\(.*\)<\/fileName>.*/\1/p;}' | sort -u | tail -n +2 >> $INCLUDE_FILE
find $SD_PATH/SAMPLES/RESAMPLE -name "*.WAV" >> $INCLUDE_FILE

#echo "PROGRESS:0"
mkdir -p "$BACKUP_PATH"
touch "$BACKUP_PATH/backup.marker"

#echo "PROGRESS:10"
#$BACKUP_SCRIPT --rsync-append-flags "-q" "$SD_PATH" "$BACKUP_PATH"
#$BACKUP_SCRIPT "$SD_PATH" "$BACKUP_PATH"
$BACKUP_SCRIPT --rsync-append-flags "--files-from=$INCLUDE_FILE" "$SD_PATH" "$BACKUP_PATH"

#echo "PROGRESS:90"
ls -lR "$SD_PATH/SAMPLES/" > "$BACKUP_PATH/sample_ls.txt"

echo $BACKUP_PATH
echo "NOTIFICATION:Deluge backup completed"
echo "done!"


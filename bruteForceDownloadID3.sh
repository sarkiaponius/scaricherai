#!/bin/bash
# File: bruteForceDownloadID3.sh
# Date: 2016-02-28
# Author: andrea
#
# Semplicemente contando, cerca di scaricare tutti gli MP3 dalla directory
# virtuale "http://www.radio.rai.it/podcast/". Ma poiché moltissimi numeri non
# corrispondono a dei veri MP3, ne scarica pochi byte iniziali da cui estrae
# eventuali tag ID3. Se essi sono presenti, e fra questi c'è TIT2, allora
# esporta tutti i tag tramite mid3v2, e con un altro script produce una INSERT
# per un apposito database
# In altre parole, serve solo a individuare file taggati per poi decidere
# successivamente quali scaricare davvero e quali no.
#

BASE="http://www.radio.rai.it/podcast"
STARTTIME=$(date +"%s")
MAX=50
CHUNK=1023

if [ $# -lt 1 ]; then
	echo "Usage: ${0##*/} <start> <stop>"
	echo "or ${0##*/} <stop> (resumes from last file)"
  exit
fi

if [ $# -eq 1 ]; then
	START=$(cat last.txt)
	STOP=$1
else
	START=$1
	STOP=$2
fi

cnt=0
for((i = $START; i <= $STOP; i += $MAX)); do 
	ID3="A$i.tag"
	if [ -e "$ID3" ] ; then
		echo "già scaricato" >&2
	else
		echo $i > last.txt
		FILES=""
		for((j = 1; j <= $MAX; j++)); do
			FILES="$FILES A#$j.mp3"
		done
		curl -s -r0-$CHUNK "$BASE/A[$i-$((i + MAX - 1))].mp3" -o $FILES
		for((j = 0; j < $MAX; j++)); do
			MP3="A$((i + j)).mp3"
			echo -n "$MP3: " >&2
			if $(mid3v2 $MP3 | grep -q TIT2) ;  then 
				echo "$(mid3v2 $MP3 | grep TIT2 | cut -d= -f2)..." >&2
				mid3v2 $MP3 > $ID3
				./insertDB.sh $ID3
			else
				echo "scartato" >&2
			fi
			rm -f $ID3
			rm -f $MP3
		done
		NOW=$(date +"%s")
		ELAPSED=$((NOW - STARTTIME))
		((cnt+=$MAX))
		echo "Centesimi per file: $((100 * (ELAPSED - 1) / cnt))" >&2
		sleep 1
	fi
done
rm -f temp.mp3

#!/bin/bash
# File: bruteForceDownloadID3.sh
# Date: 2016-02-28
# Author: andrea
#
# Semplicemente contando, cerca di scaricare tutti gli MP3 dalla directory
# virtuale "http://www.radio.rai.it/podcast/". Ma poiché moltissimi numeri non
# corrispondono a dei veri MP3, ne scarica sono 2048 byte da cui estrae
# eventuali tag ID3. Se essi sono presenti, e fra questi c'è TIT2, allora
# salva in un file Axxxxxx.tag i soli tag.
# In altre parole, serve solo a individuare file taggati per poi decidere
# successivamente quali scaricare davvero e quali no.
#
# TODO: l'intervallo di numeri per ora è fisso, ma si dovrebbe passare come
# parametro od opzione.

if [ $# -lt 2 ]; then
	echo "Usage: ${0##*/} <start> <stop>"
  exit
fi

START=$1
STOP=$2

for((i=$START;i<=$STOP;i++)); do 
	MP3="A$i.mp3"
	ID3="A$i.tag"
	if [ -e "$ID3" ] ; then
		echo "$MP3: già scaricato" >&2
	else
		curl -s -r0-1024 "http://www.radio.rai.it/podcast/$MP3" > temp.mp3
		sleep 1
		echo -n "$MP3: " >&2
		if $(mid3v2 temp.mp3 | grep -q TIT2) ;  then 
			echo "$(mid3v2 temp.mp3 | grep TIT2 | cut -d= -f2)..." >&2
			mid3v2 temp.mp3 > $ID3
			./insertDB.sh $ID3
			rm -f $ID3
		else
			echo " scartato" >&2
		fi
	fi
done
rm -f temp.mp3

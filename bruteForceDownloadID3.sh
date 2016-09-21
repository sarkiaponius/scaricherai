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
	((START-=50))
	STOP=$1
else
	START=$1
	STOP=$2
fi

cnt=0
for((i = $START; i <= $STOP; i += $MAX)); do 
	if [ -e "$ID3" ] ; then
		echo "già scaricato" >> $0.log
	else
		echo $i > last.txt

# Prepara una stringa che servirà per i file di output di curl nella sua
# modalità di multiple download

		FILES=""
		for((j = 1; j <= $MAX; j++)); do
			FILES="$FILES A#$j.mp3"
		done

# Scarica i file, ma solo i primi byte, sufficienti a capire se il file esiste
# o no. Il server infatti non risponde con codice 404, ma con un file fasullo

		curl -s -r0-30 "$BASE/A[$i-$((i + MAX - 1))].mp3" -o $FILES

# Scorre l'array A[] per creare i nomi dei file e se un file NON contiene la
# stringa fasulla procede a scaricare un pezzo iniziale contenente i tag.

		for((j = 0; j < $MAX; j++)); do
			MP3="A$((i + j)).mp3"
			ID3="A$((i + j)).tag"
			echo -n "$MP3: " >> $0.log

# Cerca la stringa fasulla

			if grep -q 'Oops! You are looking' $MP3 ; then
				echo "scartato" >> $0.log

# Non c'è la stringa, scarica un altro pezzetto che contiene tag a sufficienza

			else
				curl -s -r0-$CHUNK "$BASE/$MP3" -o $MP3
				if $(mid3v2 $MP3 | grep -q TIT2) ;  then 
					echo "$(mid3v2 $MP3 | grep TIT2 | cut -d= -f2)..." >> $0.log
					
# I tag sono salvati e ulteriormente elaborati per produrre una INSERT
# opportuna per il db.

					mid3v2 $MP3 > $ID3
					./insertDB.sh $ID3

# Se fra i tag manca TIT2 tanto vale scartare il file
					
				else
					echo "scartato" >> $0.log
				fi
			fi

			rm -f $ID3
			rm -f $MP3
		done
		NOW=$(date +"%s")
		ELAPSED=$((NOW - STARTTIME))
		((cnt+=$MAX))
		echo "Centesimi per file: $((100 * (ELAPSED - 1) / cnt))" >> $0.log
		sleep 1
	fi
done
rm -f temp.mp3

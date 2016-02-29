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

for((i=45666736;i>=45000000;i--)); do 
	curl -s -r0-2048 "http://www.radio.rai.it/podcast/A$i.mp3" > temp.mp3
	if $(mid3v2 temp.mp3 | grep -q TIT2) ;  then 
		echo "A$i.mp, registro tag ($(mid3v2 temp.mp3 | grep TIT2)...)"
		mid3v2 temp.mp3 > A$i.tag
	fi
done

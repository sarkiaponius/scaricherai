#!/bin/bash
# File: bruteForceDownloadRSS.sh
# Date: 2016-02-28
# Author: andrea
#
# Semplicemente contando, cerca di scaricare tutti i file RSS del tipo
# http://www.radio.rai.it/radio2/podcast/rssradio2.jsp?id=xxx Moltissimi
# numeri non corrispondono a dei file XML, e quindi vengono scartati. Quelli
# validi in cui c'è l'elemento "channel/title" (e almeno un elemento "item")
# sono invece salvati con questo elemento come titolo.
#

# http://www.radio.rai.it/radio3/podcast/rssradio3.jsp?id=272
# http://www.radio.rai.it/rss/podcast/rssradio.jsp?channel=WR6&id=15706

if [ $# -lt 2 ]; then
	echo "Usage: ${0##*/} <start> <stop>"
  exit
fi

START=$1
STOP=$2
BASE="http://www.radio.rai.it/radio2/podcast/rssradio2.jsp?id="
BASE="http://www.radio.rai.it/radio3/podcast/rssradio3.jsp?id="
BASE="http://www.radio.rai.it/rss/podcast/rssradio.jsp?channel=WR6&id="

for((i=$START;i<=$STOP;i++)); do 
	curl -s "$BASE$i" > temp.xml
	channel="$(xmllint --xpath '//channel/title' temp.xml 2>/dev/null | sed 's+<title>++' | sed 's+</title>++')"
	number=$(printf "%05d" $i)
	if [ -z "$channel" ] ; then 
		echo "RSS $number, channel senza title"
	else
		if $(xmllint --xpath "//channel/item" temp.xml > /dev/null 2>&1); then
			echo "RSS $number valido, lo salvo come $channel.xml..."
			xmllint --format temp.xml > "$number $channel.xml"
		else
			echo "RSS $number channel senza item"
		fi
	fi
done
#rm -f temp.xml

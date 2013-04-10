#!/usr/bin/awk -f
BEGIN \
{
	base="http://www.radio.rai.it/radio3/uomini_profeti"
	puntate=0
}
/<a href=".*.ram"/ || /class="profetic.*/ \
{
	while(/profetic1/) 
	{
		puntate++
		desc=$0
		next 
	}
	gsub("^ *<a href[^>]*>", "", desc)
	gsub("</a>", "", desc)
	rtsp=$0
	gsub("^ *<a href=\"", "", rtsp)
	gsub("\" class.*$", "", rtsp)
	printf "%s/%s\n%s\n", base, rtsp, desc
}

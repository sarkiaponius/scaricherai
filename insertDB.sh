#!/usr/bin/awk -f
#
# Inserisce i tag nel database apposito
BEGIN \
{
	FS = "="
	a = "insert into tag (file, " 
  f = ARGV[1]
  gsub("tag", "mp3", f)
	b = "values ('" f "', "
}

END \
{
	a = a ") "
	b = b ") "
	gsub(", )", ")", a)
	gsub(", )", ");", b)
	print a b
} 

/TIT2/ || /TPE1/ || /TDAT/ || /TYER/ || /TIME/ \
{
	a = a $1 ", "
	gsub("'", "''", $2)
	b = b "'" $2 "', "
}

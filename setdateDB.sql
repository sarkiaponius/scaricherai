update tag set date=str_to_date(concat(lpad(TDAT, 4, '0'),TYER,LPAD(TIME, 4,
'0')), '%d%m%Y%H%i');

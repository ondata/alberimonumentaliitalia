# Da fare
- ~~fare test su Veneto e vedere se l'ordine in output rimane quello di input~~
- ~~estrarre dati con wikidata~~
- ~~associare codice ISTAT comunale via select touch~~
- aggiungere nome file nel db

## PRO_COM

```
ogr2ogr -f CSV alberiMonumentali_tmp.csv input.vrt -dialect sqlite -sql "select A.id,A.comune, B.PRO_COM from alberimonumentali AS A, comuni AS B WHERE ST_Intersects(A.geometry,B.geometry)"
```
# scarico i dati
Ho creato lo script alberi.sh

# converto gli ods

## con pyexcel cli

    pyexcel transcode --sheet-index 0 input.ods ouput.csv

Scoperto grazie a [Andrea Enzo Guglielmo](https://www.facebook.com/andreaborruso/posts/10155399561523163?pnref=story)

## con libreoffice headless

   "C:\Program Files\LibreOffice 5\program\soffice.exe" --headless --convert-to xls --outdir "C:\Users\andybandy\aborruso@gmail.com\lavoro\opendatasicilia\idee\gli alberi monumentali del ministero\ods" "C:\Users\andybandy\aborruso@gmail.com\lavoro\opendatasicilia\idee\gli alberi monumentali del ministero\ods\Molise.ods"

## con pyexcel in csv

```python
import pyexcel
import os
from os.path import splitext

for filename in os.listdir('./'):
   pyexcel.save_as(file_name=(splitext(filename)[0]+".ods"), dest_file_name=(splitext(filename)[0])+".csv")
```

# note

- 01/I216/CT/19 ha lat e lon invertite
- colonne nascoste
- inutili righe di intestazione, e non sono sempre 4 (in Sicilia sono 5)
- ci sono celle unite
- nel file Sicilia c'è scritto Abruzzo e c'è una riga di intestazione in più
- non è possibile filtrare quello con il diametro più grande perché non è un numero
- ci sono schede duplicate 01/D927/SV/07, 01/G157/AN/11, 04/G508/KR/18 e 06/A258/RI/12
- nelle coordinate spesso c'è il carattere `’` al posto di `'`, o `’’` per `"`
- qualche volta c'è lo spazio dopo `°` o `'` e qualche volta al posto di `"` c'è `''`, come in `44° 1' 42,96''`




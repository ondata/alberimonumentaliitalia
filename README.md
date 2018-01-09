# Da fare
- fare test su Veneto e vedere se l'ordine in output rimane quello di input
- estrarre dati con wikidata
- associare codice ISTAT comunale via select touch


# scarico i dati
Ho creato lo script alberi.sh

# converto da ods in xls

## con libreoffice headless

   "C:\Program Files\LibreOffice 5\program\soffice.exe" --headless --convert-to xls --outdir "C:\Users\andybandy\aborruso@gmail.com\lavoro\opendatasicilia\idee\gli alberi monumentali del ministero\ods" "C:\Users\andybandy\aborruso@gmail.com\lavoro\opendatasicilia\idee\gli alberi monumentali del ministero\ods\Molise.ods"

## con pyexcel

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
- inutili righe di intestazione
- nel file Sicilia c'è scritto Abruzzo e c'è una riga di intestazione in più
- non è possibile filtrare quello con il diametro più grande perché non è un numero



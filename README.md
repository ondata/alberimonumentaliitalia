

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

# apro i file con pandas e li pulisco

- importare in pandas
- rimuovere inutili righe di intestazione
- inserire come nome colonna il nome del file source nell'attributo "territorio"

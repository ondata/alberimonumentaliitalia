<!-- TOC -->

- [Dove sono gli alberi monumentali d'Italia?](#dove-sono-gli-alberi-monumentali-ditalia)
    - [L'elaborazione di un dataset e un invito al ministero](#lelaborazione-di-un-dataset-e-un-invito-al-ministero)
- [Obiettivo di base: estrarre un'unica tabella per tutti gli alberi italiani](#obiettivo-di-base-estrarre-ununica-tabella-per-tutti-gli-alberi-italiani)
    - [Struttura dei file](#struttura-dei-file)
    - [Contenuti dei file](#contenuti-dei-file)
- [Gli strumenti utilizzati](#gli-strumenti-utilizzati)
- [Da fare](#da-fare)
    - [PRO_COM](#procom)
- [scarico i dati](#scarico-i-dati)
- [converto gli ods](#converto-gli-ods)
    - [con pyexcel cli](#con-pyexcel-cli)
    - [con libreoffice headless](#con-libreoffice-headless)
    - [con pyexcel in csv](#con-pyexcel-in-csv)
- [note](#note)
    - [sui dati](#sui-dati)
    - [generiche](#generiche)
- [Buone letture](#buone-letture)

<!-- /TOC -->
# Dove sono gli alberi monumentali d'Italia?
## L'elaborazione di un dataset e un invito al ministero

Da [alcune settimane](https://www.politicheagricole.it/flex/cm/pages/ServeBLOB.php/L/IT/IDPagina/12052) il **Ministero delle politiche agricole alimentari e forestali** ha dato notizia della creazione e della pubblicazione del [**primo elenco degli Alberi Monumentali d'Italia**](https://www.politicheagricole.it/flex/cm/pages/ServeBLOB.php/L/IT/IDPagina/11260).

> L'elenco, diviso per Regioni, si compone di **2407** alberi che si contraddistinguono per l'**elevato valore biologico** ed **ecologico** (età, dimensioni, morfologia, rarità della specie, habitat per alcune specie animali), per l'**importanza storica**, **culturale** e **religiosa** che rivestono in determinati contesti territoriali.

È senza ombra di dubbio un dataset interessante, che contribuirà a fare conoscere un patrimonio di grande valore, che fra l'altro penso sia poco conosciuto.

Io ho avuto da subito voglia di scoprire **quali sono gli alberi monumentali a me più vicini**. E subito dopo ho voluto una visione di insieme nel contesto nazionale. Per farlo ho creato - a partire dai dati del ministero - **un unica risorsa** in vari formati **con l'elenco degli alberi il cui iter amministrativo è completo**: 

- in formato CSV;
- in JSON;
- in GeoJSON.

**Farlo bene** e non solo per quelli vicini a me, non è stato semplice e soprattutto **non è stato immediato**. A seguire il percorso che ho seguito per estrarre i dati, da cui poi è stata derivata la mappa.

# Obiettivo di base: estrarre un'unica tabella per tutti gli alberi italiani

Sul sito del ministero (salvo che non mi sia perso qualcosa), **non c'è un file di insieme**, i dati sono pubblicati distinti su due raggruppamenti di file: uno per gli "**alberi il cui iter amministrativo di iscrizione è completo**" e l'altro per quelli ancora da perfezionare. Ho concentrato la mia attenzione sul primo.<br>
Questo contiene un elenco di **21 fogli di calcolo** in formato *Open Document* (`.ods`): 19 regioni e le 2 province autonome di Bolzano e Trento.

La prima cosa necessaria era **farne un'analisi** e subito - aprendoli -  salta all'occhio che sono file **predisposti per essere letti a video e/o stampati** e **non per essere sottoposti ad analisi**.

## Struttura dei file

Tutti i file hanno almeno **4 righe di intestazione** (vedi `1` nell'immagine di sotto). Una regola di base che non ce ne sia più di una.

Inoltre ci sono **celle unite**  (ad esempio `2` e `3` nell'immagine di sotto) e righe vuote utilizzate soltanto per creare una linea colorata di separazione (`4` nell'immagine di sotto). Un'altre regola da seguire nella pubblicazione di fogli elettronici, nel caso di dati pubblicati per essere analizzati, è quello di **non avere mai unione di celle** e nemmeno righe come la `4`.

![](./imgs/intestazione.png)

Nel [file `.ods` della Sicilia](https://www.politicheagricole.it/flex/cm/pages/ServeAttachment.php/L/IT/D/8%252F2%252F7%252FD.c56d35617c024a59f0c9/P/BLOB%3AID%3D11260/E/ods), ci sono delle **colonne nascoste** (`P`,`Q`,`R` e `S`). Andrebbero rese visibili.

I **nomi delle colonne** contengono **caratteri da rimuovere**. Ad esempio quello che contiene i valori dell'altezza - `ALTEZZA                      (m)` - contiene 22 spaziature tra `ALTEZZA` e `(m)`; andrebbero ridotte a una.

## Contenuti dei file

**Due campi** che si sono rivelati con contenuti **particolarmente problematici**, essenziali fra l'altro per visualizzare dove sono posizionati questi alberi, sono stati quelli che contengono la **longitudine** e la **latitudine**: `LONGITUDINE su GIS` e `LATITUDINE su GIS`.

Per due ragioni principali:

- **non contengono valori espressi in formato numerico** (come è raccomandato che siano le coordinate);
- ci sono svariate modalità in cui sono sono espresse, dovute probabilmente a **errori di battitura**.

Un esempio è quello della coppia `37°37'12,21"` e `15°10'24,99"`. Alcuni sistemi informativi geografici sono in grado di importare coppie di coordinate scritte in questo modo (non in forma numerica), ma è necessario che i caratteri usati per indicare `gradi`, `minuti` e `secondi` siano usati in modo omogeneo e corretto. Così come è bene che la scelta di eventuali spaziature sia omogenea. 

A seguire alcuni esempi, che potranno sembrare corretti. Ma "il diavolo è nei dettagli", qui riportati nella colonna `nota`:

|latitudine|longitudine|scheda|nota|
|---|---|---|---|
|46°30'00,62''|11°210'53,66''|02/A952/BZ/21|Nella longitudine sono riportati `210` primi, che non è valore possibile. Per indicare i secondi è stato usato due volte l'apice singolo `'` (successivamente è evidenziata una mancanza di omogeneità nella scelta del carattere).|
|40°30'01,04"|15°2302,03"|01/G509/SA/15|Nella longitudine non c'è il carattere `'` per i primi. Per indicare i secondi qui sono usate le virgolette `"`.|
|44°45'59,50''|10°26'17',78"|02/D934/RE/08|Nella longitudine i primi sono indicati due volte.|
|41°53'00,06"|12°27 49,29"|09/H501/RM/12|Nella longitudine non c'è il carattere `'` per i primi e c'è uno spazio.|
|45°01'04,48''|7°56'27',20'|01/B306/AT/01|Nella longitudine per i secondi è usato l'apice singolo.|
|39°42'54,63"|9°02'9.,6'"|01/D997/VS/20|Nella longitudine ci sono due caratteri per indicare il separatore decimale dei secondi (`.,`).|

**Nel campo `N. SCHEDA` ci sono dei duplicati**. Non posso essere certo che sia un errore, ma mi sembra utile segnalarlo: si tratta delle schede `01/D927/SV/07`, `01/G157/AN/11`, `04/G508/KR/18 e 06/A258/RI/12`.

Ci sono **diversi casi di spaziature inutili a fine cella**. Nella colonna `LOCALITÀ` abbiamo ad esempio `Villa comunale ` e `Castiglione ` (con uno spazio in più dopo l'ultima vocale). Questo rende più difficile l'incrocio di questi dati con altri, perché laddove c'è uno spazio in più sarà impossibile fare una correlazione con nomi di luoghi scritti correttamente.

In ultimo una nota su aspetto più botanico, legata alla classificazione. Potrebbe essere scorretta, perché non sono un esperto di dominio.<br>Per ogni albero è indicato il nome scientifico, ma **non uno degli identificatori internazionali possibili per una specie arborea**. <br>Il "*Pinus nigra* J.F.Arnold" (una delle specie presenti) corrisponde ad esempio all'identificatore [58042](https://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=Info&id=58042) del "Taxonomy Database by the National Center for Biotechnology Information", o all'identificatore [kew-2562349](http://www.theplantlist.org/tpl1.1/record/kew-2562349) del "The Plant List".<br>Usare uno degli identificatori standard e internazionali (non sono sicuro che questi due lo siano, sono inseriti come esempi di identicatori) consentirebbe di incrociare facilmente questo dataset con numerosi altri e di derivare decine di altre informazioni correlate, come ad esempio una foto di un albero di una data specie. <br>È uno dei principi fondanti dei *Linked Open Data*.

# Gli strumenti utilizzati

Per creare questo dataset ho scritto uno *script* `bash`. Non sono molto soffisfatto del risultato ottenuto in termini di leggibilità e eleganza; mi sono dedicato sopratutto a raggiungere l'obiettivo.

Nello script sono state utilizzate queste utility:
- **cURL**, per accedere a risorse web, [https://curl.haxx.se/](https://curl.haxx.se/);
- **jq**, per elaborare dati in formato `JSON`, [https://stedolan.github.io/jq/](https://stedolan.github.io/jq/);
- **csvkit**, per elaborare dati in formato `CSV`, [https://csvkit.readthedocs.io](https://csvkit.readthedocs.io)
- **pyexcel-cli**, per convertire a riga di comando i file `.ods` in `.csv`, [https://pyexcel-cli.readthedocs.io](https://pyexcel-cli.readthedocs.io) (grazie a [Andrea Enzo Guglielmo](https://www.facebook.com/andreaborruso/posts/10155399561523163?pnref=story) per avermelo fatto conoscere);
- **perl** (di solito preinstallato), per trasformare stringhe di testo usando le espressioni regolari;
- **cs2cs**, per convertire in formato numerico i valori di longitudine e latitudine, qui espressi come stringhe di testo, [http://proj4.org/apps/cs2cs.html](http://proj4.org/apps/cs2cs.html).

# Da fare
- ~~fare test su Veneto e vedere se l'ordine in output rimane quello di input~~
- ~~estrarre dati con wikidata~~
- ~~associare codice ISTAT comunale via select touch~~
- ~~aggiungere nome file nel db~~
- mappa su uMap o su Carto con 
- file CSV e JSON unico con i dati grezzi;

## PRO_COM

```
ogr2ogr -f CSV alberiMonumentali_tmp.csv input.vrt -dialect sqlite -sql "select A.id,A.comune, B.PRO_COM from alberimonumentali AS A, comuni AS B WHERE ST_Intersects(A.geometry,B.geometry)"
```
# scarico i dati
Ho creato lo script alberi.sh

# converto gli ods

## con pyexcel cli

        

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

## sui dati

- 01/I216/CT/19 ha lat e lon invertite
- ~~colonne nascoste~~
- ~~inutili righe di intestazione, e non sono sempre 4 (in Sicilia sono 5)~~
- ~~ci sono celle unite~~
- ~~nel file Sicilia c'è scritto Abruzzo e c'è una riga di intestazione in più~~
- non è possibile filtrare quello con il diametro più grande perché non è un numero
- ~~ci sono schede duplicate 01/D927/SV/07, 01/G157/AN/11, 04/G508/KR/18 e 06/A258/RI/12~~
- ~~nelle coordinate spesso c'è il carattere `’` al posto di `'`, o `’’` per `"`~~
- ~~qualche volta c'è lo spazio dopo `°` o `'` e qualche volta al posto di `"` c'è `''`, come in `44° 1' 42,96''`~~

## generiche

- è un dataset di grande interesse. Queste mie parole sono un invito, non una paletta con un voto;
- street view;
- wikipedia wikidata;
- regex odioso https://regex101.com/r/Tkc9Tn/6
- qual è il più largo? Qual è il più piccolo

# Buone letture

- [Releasing data or statistics in spreadsheets](http://www.clean-sheet.org/);
- [The Quartz guide to bad data](https://github.com/Quartz/bad-data-guide);
- [Cleaner, Smarter Spreadsheets Start with Structure](https://source.opennews.org/articles/building-cleaner-smarter-spreadsheets/).
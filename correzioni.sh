#!/bin/bash

sqlite3 nomeDb.db <<EOF
-- per usare questo script occorre creare prima un db.db
-- nel seguente modo: $ sqlite3 nomeDb.db
-- si avvierà sqlite con db pronto all''uso
--
.mode csv alberiMonumentali
.import alberiMonumentali.csv alberiMonumentali

-- legge modulo per il regex
.load /usr/lib/sqlite3/pcre.so

-- correzione spazi iniziali e finali
-- campo PROVINCIA
UPDATE "alberiMonumentali" SET "PROVINCIA" = TRIM("PROVINCIA");

-- campo COMUNE
UPDATE "alberiMonumentali" SET "COMUNE" = TRIM("COMUNE");

-- campo LOCALITÀ
UPDATE "alberiMonumentali" SET "LOCALITÀ" = TRIM("LOCALITÀ");

-- campo PROPOSTA DICHIARAZIONE NOTEVOLE INTERESSE PUBBLICO
UPDATE "alberiMonumentali" SET "PROPOSTA DICHIARAZIONE NOTEVOLE INTERESSE PUBBLICO" = 
TRIM("PROPOSTA DICHIARAZIONE NOTEVOLE INTERESSE PUBBLICO");


-- correzione campo CONTESTO_URBANO sì/no
UPDATE "alberiMonumentali" SET "CONTESTO URBANO sì/no" = 'sì'
WHERE "CONTESTO URBANO sì/no" regexp '.*[sS].*';
UPDATE "alberiMonumentali" SET "CONTESTO URBANO sì/no" = 'no'
WHERE "CONTESTO URBANO sì/no" regexp '.*[nN].*';

-- correzione campo PROVINCIA
UPDATE "alberiMonumentali" SET "PROVINCIA" = 'Verbano Cusio Ossola'
WHERE "PROVINCIA" regexp 'Verbano Cusio.*';
UPDATE "alberiMonumentali" SET "PROVINCIA" = 'Monza Brianza'
WHERE "PROVINCIA" regexp 'Monza.*';

-- correzione campo  PROPOSTA DICHIARAZIONE NOTEVOLE INTERESSE PUBBLICO
UPDATE "alberiMonumentali" SET "PROPOSTA DICHIARAZIONE NOTEVOLE INTERESSE PUBBLICO" = 'sì'
WHERE "PROPOSTA DICHIARAZIONE NOTEVOLE INTERESSE PUBBLICO" = 'si';

-- esporto in csv
.headers on
.mode csv
.output alberiMonumentali_v01.csv
SELECT * FROM alberiMonumentali;
.quit
EOF
rm ./nomeDb.db
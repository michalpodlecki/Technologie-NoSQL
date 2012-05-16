Technologie NoSQL
=================

Repozytorium na potrzeby laboratorium.

---------------------

* Skrypt ruby zapisujący dane do bazy MongoDB:
`ruby import2mongo.db json_file [-p port] [-d database] [-c collection]`

* Skrypt ruby przenoszący dane z bazy MongoDB do CouchDB:
`ruby mongo2couch.rb mongodb_port mongodb_database mongodb_collection couchdb_port [couchdb_database [--override]]`

 **Wydajność:**

 Przeprowadziłem test porównujący prędkość kopiowania dokumentów z bazy MongoDB do CouchDB w sposób pojedynczy i wsadowy (batch copy).

 Do testów posłużyła mi kolekcja *toks* bazy *poliqarp* ze strony [WB@NoSQL//Zadania](http://wbzyl.inf.ug.edu.pl/nosql/zadania), zadanie z działu **MongoDB**.

 Kolekcja ta zawiera 661839 dokumentów i zajmuje 0.25 GB pamięci na dysku (baza MongoDB).

 Wyniki testu:

 * kopiowanie pojedyncze:
 
     `Czas wykonywania: ~13546 sekund (~3h 46min) !`

     `Rozmiar bazy: 3.86 GB !`

 * kopiowanie wsadowe (partie po 1000 dokumentów):

     `Czas wykonywania: 235 sekund`

     `Rozmiar bazy: 221.4 MB`

 Rezultat mówi sam za siebie, kopiowanie wsadowe (hurtowe) rządzi.
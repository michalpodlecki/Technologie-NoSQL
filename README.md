Technologie NoSQL
=================

Repozytorium na potrzeby laboratorium.

---------------------

* Skrypt ruby zapisujący dane do bazy MongoDB:
`ruby import2mongo.db json_file [-p port] [-d database] [-c collection]`

* Skrypt ruby przenoszący dane z bazy MongoDB do CouchDB:
`ruby mongo2couch.rb mongodb_port mongodb_database mongodb_collection couchdb_port [couchdb_database [--override]]`

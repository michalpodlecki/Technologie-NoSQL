require "mongo"
require "json"
require "couchrest"

if ARGV[0] == "-h" || ARGV[0] == "--help" || ARGV.size < 4 then
  puts "\nWywolanie skryptu:\n"
  puts "    > ruby #{__FILE__} mongodb_port mongodb_database mongodb_collection couchdb_port[ couchdb_database]"
  puts
  puts "Objasnienia:"
  puts "    couchdb_database\tnazwa bazy CouchDB, do ktorej przekopiowane zostana dane"
  puts "\t\t\t(domyslnie nazwa kolekcji MongoDB)"
  # puts "( domyslna nazwa bazy CouchDB jest nazwa kolekcji CouchDB )"
  puts
  exit
end

mongoPort = ARGV[0]
couchPort = ARGV[3]
mongoDB = ARGV[1]
collection = ARGV[2]
dbName = ARGV[4] || collection

puts "[Settings]"
puts "MongoDB port:\t\t#{mongoPort}"
puts "MongoDB database:\t#{mongoDB}"
puts "MongoDB collection:\t#{collection}"
puts
puts "CouchDB port:\t\t#{couchPort}"
puts "CouchDB database:\t#{dbName}"
puts

connection = Mongo::Connection.new("localhost",mongoPort)

db = connection.db(mongoDB)

coll = db.collection(collection)

jsons = []
coll.find.to_a.each do |item|
  jsons.push item
end

couchDB = CouchRest.database("http://localhost:#{couchPort}/" + dbName)
couchDB.recreate! # tworze baze na nowo 

jsons.collect do |row|
  row.delete("_id") # usuwam pole _id oraz id
  row.delete("id")
end

puts "Kopiowanie danych w toku..."
couchDB.bulk_save(jsons)
puts "Kopiowanie zakonczone."
puts
puts "Baze mozesz sprawdzic pod adresem: http://localhost:#{couchPort}/_utils/database.html?#{dbName}"

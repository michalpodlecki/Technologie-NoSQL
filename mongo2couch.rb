require "mongo"
require "json"
require "couchrest"

if ARGV[0] == "-h" || ARGV[0] == "--help" || !ARGV[0] || !ARGV[1] || ARGV[0].to_i == 0 || ARGV[1].to_i == 0 then
  puts "\nWywolanie skryptu:\n"
  puts "> ruby #{__FILE__} [port serwera mongodb] [port serwera couchdb]"
  puts
  exit
end

mongoPort = ARGV[0]
couchPort = ARGV[1]

dbName = "nosql-lab-db"

connection = Mongo::Connection.new("localhost",mongoPort)

db = connection.db(dbName)

coll = db.collection("movies")

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
puts "---"
puts "Kopiowanie zakonczone."
puts
puts "Baze mozesz sprawdzic pod adresem: http://localhost:#{couchPort}/_utils/database.html?#{dbName}"

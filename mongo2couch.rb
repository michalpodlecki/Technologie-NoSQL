require "mongo"
require "json"
require "couchrest"

if ARGV[0] == "-h" || ARGV[0] == "--help" || ARGV.size < 4 then
  puts "\nWywolanie skryptu:\n"
  puts "    > ruby #{__FILE__} mongodb_port mongodb_database mongodb_collection couchdb_port [couchdb_database [--override]]"
  puts
  puts "Objasnienia:"
  puts "    couchdb_database\tnazwa bazy CouchDB, do ktorej przekopiowane zostana dane"
  puts "\t\t\t(domyslnie nazwa kolekcji MongoDB)"
  puts "\t\t\tSkrypt tworzy baze o podanej nazwe, jesli taka nie istnieje."
  puts "    --override\t\tNADPISUJE wpisy w bazie! (operacja bezpowrotna)"
  # puts "( domyslna nazwa bazy CouchDB jest nazwa kolekcji CouchDB )"
  puts
  exit
end

mongoPort = ARGV[0]
couchPort = ARGV[3]
mongoDB = ARGV[1]
collection = ARGV[2]
dbName = ARGV[4] || collection
override = ARGV.size == 6 && ARGV[5] == "--override"

puts "\n[Settings]"
puts "MongoDB port:\t\t#{mongoPort}"
puts "MongoDB database:\t#{mongoDB}"
puts "MongoDB collection:\t#{collection}"
puts
puts "CouchDB port:\t\t#{couchPort}"
puts "CouchDB database:\t#{dbName}"
puts
puts "Nadpisz dane:\t\t" << (override ? "TAK!" : "nie")
puts "-------------------------------------------------"
puts

connection = Mongo::Connection.new("localhost",mongoPort)

db = connection.db(mongoDB)

coll = db.collection(collection)

jsons = []

couchDB = CouchRest.database!("http://localhost:#{couchPort}/" + dbName)
couchDB.recreate! if override # tworze baze na nowo 

puts "Rozpoczynam kopiowanie..."
offset = 1
batch_size = 1000
count = coll.count
while offset * batch_size - batch_size < count do
  jsons = coll.find(nil,{:limit => batch_size, :skip => (offset * batch_size - batch_size)}).to_a
  jsons.collect do |item|
    item.delete("_id") # usuwam pole _id
    # puts "Skopiowano: " << couchDB.save_doc(item)["id"]
  end
  couchDB.bulk_save(jsons)
  progress = ((offset.to_f * batch_size)/count) * 100
  puts "przekopiowano " << progress.round(1).to_s << "%"
  offset += 1
end


puts "Kopiowanie zakonczone."
puts
puts "Baze mozesz sprawdzic pod adresem: http://localhost:#{couchPort}/_utils/database.html?#{dbName}"
puts
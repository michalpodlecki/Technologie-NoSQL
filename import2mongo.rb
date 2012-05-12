require "mongo"
require "json"

if ARGV[0] == "-h" || ARGV[0] == "--help" || ARGV.size == 0 then
  puts "\nWywolanie skryptu:\n"
  puts "> ruby #{__FILE__} json_file [-p port][ -d database][ -c collection]"
  puts
  exit
end

filename = ARGV[0].downcase

if File.extname(filename) != ".json"
  puts "Nieprawidlowe rozszerzenie pliku JSON"
  exit
end

port, database, collection = 27017, "test", "movies"
options = {"-p" => port,"-d" => database,"-c" => collection}

if ARGV.size > 0
  size = ARGV.size
  arg = ARGV[0]
  if size % 2 == 1
    options.each do |key,val|
      index = ARGV.index(key)
      if index then
        options[key] = ARGV[index+1]
      end
    end
  else
    puts "Niepoprawna ilosc argumentow"
    exit
  end
end

puts "[Settings]"
puts "port:\t\t#{options["-p"]}\ndatabase:\t#{options["-d"]}\ncollection:\t#{options["-c"]}"
puts

connection = Mongo::Connection.new("localhost",options["-p"])

db = connection.db(options["-d"])

coll = db.collection(options["-c"])

# drop all documents first if exists
coll.remove

file = File.new filename

puts "Import danych w toku..."

file.each_line do |line|
  line = line[1...-1]
  arrayOfJSONs = []
  arrayOfJSONs = line.split(/}, /)
  arrayOfJSONs.map {|item| item << "}"}
  sizeOfLastEl = arrayOfJSONs[-1].size
  arrayOfJSONs[-1] = arrayOfJSONs[-1][0,sizeOfLastEl - 2]
  
  index = 0
  arrayOfJSONs.each do |value|
    json = JSON.parse(value)
    coll.insert(json)
    index += 1
    break if index == 5000
  end
end

puts "Import danych zakonczony."
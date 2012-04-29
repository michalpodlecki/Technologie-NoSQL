require "mongo"
require "json"

if ARGV[0] == "-h" || ARGV[0] == "--help" || !ARGV[0] || ARGV[0].to_i == 0 then
  puts "\nWywolanie skryptu:\n"
  puts "> ruby #{__FILE__} [port]"
  puts
  exit
end

port = ARGV[0]

connection = Mongo::Connection.new("localhost",port)

db = connection.db("nosql-lab-db")

coll = db.collection("movies")

# drop all documents first if exists
coll.remove

file = File.new "filmy_movies.json"

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
    #puts json
    coll.insert(json)
    index += 1
    break if index == 5000
  end
end

puts "---"
puts "Import danych zakonczony."

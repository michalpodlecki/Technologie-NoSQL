require "mongo"
require "json"

connection = Mongo::Connection.new("localhost",40012)

#connection.database_info.each_value { |e| puts e }

db = connection.db("nosql-lab-db")

coll = db.collection("movies")

# drop all documents first if exists
coll.remove

file = File.new "filmy_movies.json"

file.each_line do |line|
  # puts line
  # break
  line = line[1...-1]
  arrayOfJSONs = []
  arrayOfJSONs = line.split(/}, /)
  # puts arrayOfJSONs[-1]; break
  arrayOfJSONs.map {|item| item << "}"}
  # puts arrayOfJSONs[0]
  sizeOfLastEl = arrayOfJSONs[-1].size
  # puts "size: #{size}"
  arrayOfJSONs[-1] = arrayOfJSONs[-1][0,sizeOfLastEl - 2]
  # puts arrayOfJSONs[-1]
  # break
  
  index = 0
  arrayOfJSONs.each do |value|
    json = JSON.parse(value)
    puts json
    coll.insert(json)
    index += 1
    break if index == 5000
  end
end


require "http"
require "json"

pp "Enter a location you wanted me to check"
location = gets.chomp

GMAPS_KEY = ENV.fetch("GMAPS_KEY")
location_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{location}&key=#{GMAPS_KEY}"

raw_location_url = HTTP.get(location_url)
#pp raw_location_url

parsed_location_url = JSON.parse(raw_location_url)
#pp parsed_location_url

results_hash = parsed_location_url.fetch("results")
#pp geometry_hash

geometry_array = results_hash.at(0)
#pp geometry_array

geometry_hash = geometry_array.fetch("geometry")
#pp geometry_hash

location_hash = geometry_hash.fetch("location")
#pp location_hash

lat = location_hash.fetch("lat")
lng = location_hash.fetch("lng")
pp "#{lat} #{lng}"



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

geometry_hash = parsed_location_url.fetch("results")
pp geometry_hash

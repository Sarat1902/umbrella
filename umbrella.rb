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
#pp "#{lat} #{lng}"

pirate_weather_key = ENV.fetch("PIRATE_WEATHER_KEY")
pirate_weather_url = "https://api.pirateweather.net/forecast/#{pirate_weather_key}/#{lat},#{lng}"

raw_pirate_weather_url = HTTP.get(pirate_weather_url)
parsed_pirate_weather_url = JSON.parse(raw_pirate_weather_url)
#pp parsed_pirate_weather_url

currently_hash = parsed_pirate_weather_url.fetch("currently")
#pp currently_hash

current_temp = currently_hash.fetch("temperature")
pp "The current temperatue is: #{current_temp}"

current_summary = currently_hash.fetch("summary")
pp " The current situation is: #{current_summary}"








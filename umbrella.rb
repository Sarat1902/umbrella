require "http"
require "json"
require 'ascii_charts'


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

# Next hour summary
minutely_hash = parsed_pirate_weather_url.fetch("minutely")
if minutely_hash 
  next_hour_summary = minutely_hash.fetch("summary")
  pp "The next hour situation is: #{next_hour_summary}"
end

# Next 12 hours summary
hourly_hash = parsed_pirate_weather_url.fetch("hourly")
hourly_data_array = hourly_hash.fetch("data")
next_twelve_hours = hourly_data_array[1..12]
precip_prob_threshold = 0.10
any_precp = false

next_twelve_hours.each do |x|
   precip_prob = x.fetch("precipProbability")
   pp precip_prob

   if precip_prob > precip_prob_threshold
    any_precp = true
    precip_time = Time.at(x.fetch("time"))
    seconds = precip_time - Time.now
    hours = seconds / 60 / 60
    pp "In #{hours.round} from now, There is a chance of #{precip_prob * 100} % of precipitation probability"
   end  

  end

if any_precp == true
  pp "You might want to carry an umbrella!"
else
  pp "You probably won’t need an umbrella today."
end

## Ascii Chart

i = 0
array = []
next_twelve_hours.each do |x|
   precip_prob = x.fetch("precipProbability")
   precip_time = Time.at(x.fetch("time"))
   seconds = precip_time - Time.now
   hours = seconds / 60 / 60
   array[i] = [hours.round,precip_prob.round] 
   i +=1
  end  

pp array
puts AsciiCharts::Cartesian.new(array).draw

require 'sinatra'
require 'forecast_io'
require 'json'
require 'geocoder'

configure do
	ForecastIO.api_key = ENV['FORECASTIO_KEY']
	@@lat = 42.3654347
	@@lng = -71.258595
end

get '/' do
	erb :main
end

get '/weather' do
	erb :weather
end

get '/apparentTemperature' do
	"T: #{ForecastIO.forecast(@@lat, @@lng)[:currently][:apparentTemperature]}"
end

get '/precipProbability' do
	"P: #{ForecastIO.forecast(@@lat, @@lng)[:currently][:precipProbability]*100}"
end

get '/summary' do
	"#{ForecastIO.forecast(@@lat, @@lng)[:currently][:summary]}"
end

get '/updatelatlng/:address' do
	latlng = Geocoder.coordinates(params[:address])
	puts 'updating lat lng'
	puts "old lat is #{@@lat}"
	puts "old lng is #{@@lng}"
	@@lat = latlng[0]
	@@lng = latlng[1]
	puts "new lat is #{@@lat}"
	puts "new lng is #{@@lng}"
	redirect to '/weather'
end
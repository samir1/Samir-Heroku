require 'sinatra'
require 'forecast_io'

configure do
	ForecastIO.api_key = ENV['FORECASTIO_KEY']
	@@lat = 29.779312
	@@lng = -95.460570
end

get '/' do
	erb :main
end

get '/apparentTemperature' do
	"#{ForecastIO.forecast(@@lat, @@lng)[:currently][:apparentTemperature]}"
end

get '/precipProbability' do
  "#{ForecastIO.forecast(@@lat, @@lng)[:currently][:precipProbability]}"
end

get '/summary' do
	"#{ForecastIO.forecast(@@lat, @@lng)[:currently][:summary]}"
end

get '/updatelatlng/:lat/:lng' do
	puts 'updating lat lng'
	puts "old lat is #{@@lat}"
	puts "old lng is #{@@lng}"
	@@lat = params[:lat]
	@@lng = params[:lng]
	puts "new lat is #{@@lat}"
	puts "new lng is #{@@lng}"
	redirect to '/'
end
require 'sinatra'
require 'forecast_io'
require 'json'

configure do
	ForecastIO.api_key = ENV['FORECASTIO_KEY']
	@@lat = 29.779312
	@@lng = -95.460570
end

get '/' do
	erb :main
end

get '/apparentTemperature.json' do
	content_type :json
	"|Temp: #{ForecastIO.forecast(@@lat, @@lng)[:currently][:apparentTemperature]}"
end

get '/precipProbability.json' do
	content_type :json
	"|Precip: #{ForecastIO.forecast(@@lat, @@lng)[:currently][:precipProbability]*100}"
end

get '/summary.json' do
	content_type :json
	"|#{ForecastIO.forecast(@@lat, @@lng)[:currently][:summary]}"
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
#!/usr/bin/env ruby

require 'sinatra'
require 'forecast_io'
require 'json'
require 'geocoder'
require 'open-uri'

configure do
	ForecastIO.api_key = ENV['FORECASTIO_KEY']
	@@lat = 41.512538
	@@lng = -81.604228
end

helpers do
  def protected!
    return if authorized?
    headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
    halt 401, "Not authorized\n"
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == [ENV['SAMIR_HEROKU_USERNAME'], ENV['SAMIR_HEROKU_PASSWORD']]
  end
end

get '/lamp' do
  protected!
  erb :lamp
end

get '/lamp_on' do
  protected!
  open(ENV['LAMP_URL']+'on', :http_basic_authentication=>[ENV['LAMP_USERNAME'], ENV['LAMP_PASSWORD']])
end

get '/lamp_off' do
  protected!
  open(ENV['LAMP_URL']+'off', :http_basic_authentication=>[ENV['LAMP_USERNAME'], ENV['LAMP_PASSWORD']])
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

get '/apparentTemperature.json' do
	content_type :json
	"|T: #{ForecastIO.forecast(@@lat, @@lng)[:currently][:apparentTemperature]}"
end

get '/precipProbability.json' do
	content_type :json
	"|P: #{ForecastIO.forecast(@@lat, @@lng)[:currently][:precipProbability]*100}"
end

get '/summary.json' do
	content_type :json
	"|#{ForecastIO.forecast(@@lat, @@lng)[:currently][:summary]}"
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
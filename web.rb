# encoding: utf-8
require 'sinatra'
require 'sinatra/contrib'
require 'sinatra/reloader' if development?
require 'json'
require 'time'
require 'sequel'

require './models'

class MetricsCalculator
  @@equivalences = [
    {savings: 1, savings_format: "%d", savings_metric: :mts2, savings_subject: 'de bosques', savings_image: 'plant'},
    {savings: 119, savings_format: "%d", savings_metric: :grs, savings_subject: 'de CO2', savings_image: 'smoke'},
    {savings: 0.0022, savings_format: "%.2f", savings_metric: :lts, savings_subject: 'de petróleo', savings_image: 'oil'}
  ]
  def self.calculate(event)
    equivalence = @@equivalences.sample
    {
      savings: equivalence[:savings_format] % (equivalence[:savings]*event.count),
      savings_metric: equivalence[:savings_metric],
      savings_subject: equivalence[:savings_subject],
      savings_image: equivalence[:savings_image]
    }
  end
end

get '/' do
  erb :index, locals: {events: Event.all}
end

post '/bin/:id/dispose', provides: :json do
  bin = bin_by_id(params[:id])
  count = params[:count] || 1
  Disposal.create(bin: bin, count: count, created_at: Time.now)
  bin.to_hash.to_json
end

get '/event/new' do
  erb :create_event, locals: {bins: Bin.all}
end

post '/event/new' do
  #begin
  #  params[:image] = params[:image][:tempfile].read
  #rescue Exception => e
  #  puts 'Something went wrong reading image', e
  #end
  event = Event.create(sub_hash(params, :name, :description))
  bins = Bin.where(id: params[:bins]).all
  bins.each { |b| event.add_bin(b) }
  redirect "/event/#{event.id}"
end

get '/event/:id' do
  event = event_by_id(params[:id])
  respond_to do |f|
    f.html { erb :event, locals: {event: event} }
    f.json { event.to_hash.merge(MetricsCalculator.calculate(event)).to_json }
  end
end

not_found do
  '<img src="http://httpcats.herokuapp.com/404.jpg">'
end

helpers do
  def bin_by_id(id)
    Bin[id] || halt(404)
  end

  def event_by_id(id)
    Event[id] || halt(404)
  end

  def sub_hash(hash, *keys)
    res = {}
    keys.each { |k| res[k] = hash[k] }
    res
  end
end
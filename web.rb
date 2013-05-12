require 'sinatra'
require 'sinatra/contrib'
require 'sinatra/reloader' if development?
require 'json'
require 'time'
require 'sequel'

require './models'

class MetricsCalculator
  @@equivalences = [
    {savings: 1, savings_metric: :has, savings_subject: 'de bosques', savings_image: 'plant'},
    {savings: 3, savings_metric: :grs, savings_subject: 'de CO2', savings_image: 'smoke'}
  ]
  def self.calculate(bin)
    equivalence = @@equivalences.sample
    {
      savings: equivalence[:savings]*bin.count,
      savings_metric: equivalence[:savings_metric],
      savings_subject: equivalence[:savings_subject],
      savings_image: equivalence[:savings_image]
    }
  end
end

get '/' do
  erb :index, locals: {bins: Bin.all}
end

get '/bin/:id' do
  bin = bin_by_id(params[:id])
  respond_to do |f|
    f.html { erb :bin, locals: {bin: bin} }
    f.json { bin.to_hash.merge(MetricsCalculator.calculate(bin)).to_json }
  end
end

post '/bin/:id/dispose', provides: :json do
  bin = bin_by_id(params[:id])
  count = params[:count] || 1
  Disposal.create(bin: bin, count: count, created_at: Time.now)
  bin.to_hash.to_json
end

not_found do
  '<img src="http://httpcats.herokuapp.com/404.jpg">'
end

helpers do
  def bin_by_id(id)
    Bin[id] || halt(404)
  end
end
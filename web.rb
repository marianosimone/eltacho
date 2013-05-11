require 'sinatra'
require 'sinatra/contrib'
require 'sinatra/reloader' if development?
require 'json'
require 'time'
require 'sequel'

require './models'

get '/' do
  erb :index, locals: {bins: Bin.all}
end

get '/bin/:id' do
  bin = Bin[params[:id]]
  return 404 unless bin
  respond_to do |f|
    f.html { erb :bin, locals: {bin: bin} }
    f.json { bin.to_hash.to_json }
  end
end

post '/bin/:id/dispose', provides: :json do
  id = params[:id]
  count = params[:count] || 1
  bin = Bin[id]
  return 404 unless bin
  Disposal.create(bin: bin, count: count, created_at: Time.now)
  bin.to_hash.to_json
end
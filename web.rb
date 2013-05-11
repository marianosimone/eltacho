require 'sinatra'
require 'sinatra/reloader' if development?
require 'json'
require 'time'
require 'sequel'

require './models'

get '/' do
    erb :index, locals: {tachos: [1,2,3,4,5,6]}
end

get '/bin/:id.?:format?' do
    if params[:format] == "json"
        content_type :json
        return  {time: Time.now, count: 1}.to_json
    else
        class Bin
            attr_reader :name
            def initialize()
                @name = 'pepe'
            end
        end
        erb :bin, locals: {bin: Bin.new()}
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
require 'sinatra'
require 'sinatra/reloader' if development?
require 'json'
require 'time'

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
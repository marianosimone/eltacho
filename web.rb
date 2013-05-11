require 'sinatra'
require 'sinatra/reloader' if development?
require 'json'

get '/' do
    erb :index, locals: {tachos: [1,2]}
end

get '/bin' do
    class Bin
        attr_reader :name
        def initialize()
            @name = 'pepe'
        end
    end
    erb :bin, locals: {bin: Bin.new()}
end

get '/bin/:name' do
    content_type :json
    puts params[:name]
    return  {time: 2, count: 1}.to_json
end
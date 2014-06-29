require 'sinatra'
require 'haml'
require 'sinatra/activerecord'
require 'coffee-script'
require 'sinatra/assetpack'

class App < Sinatra::Base
  #before do
  #  content_type :json
  #end

  get '/' do
    haml :index
  end

  get '/create' do
    haml :create
  end


  get '/api' do
    haml :api
  end

  # create or update stash
  # POST /stash
  # content - text, tags - string
  post '/stash' do
    return(head :bad_request) unless params[:tags] && params[:content]

    stash = Stash.new
    stash.gen_digest params[:tags]
    if founded = Stash.find_by(digest: stash.digest)
      founded.contentable.content = params['content']
      founded.contentable.save
      return {result: :updated}.to_json
    end
    message = Message.create(content: params['content'])
    stash.contentable = message
    if stash.save
      {result: :created}.to_json
    else
      {result: :error}.to_json
    end
  end

  # get stash by tags
  # GET /stash
  # tags - string

  get '/stash' do
    return(head :bad_request) unless params[:tags]
    helper = Stash.new
    helper.gen_digest params[:tags]
    stash = Stash.find_by(digest: helper.digest)
    if stash
      {result: stash.contentable.content}.to_json
    else
      {result: 'Ничего не найдено'}.to_json
    end
  end

  delete '/stash' do
    return(head :bad_request) unless params[:tags]
    helper = Stash.new
    helper.gen_digest params[:tags]
    stash = Stash.find_by(digest: helper.digest)
    if stash && stash.destroy
      {result: :deleted}.to_json
    else
      {result: :error}.to_json
    end
  end

end
require_relative 'models/init'
require_relative 'helpers/init'
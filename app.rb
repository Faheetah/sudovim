require 'sinatra'
require './Post'
require './Search'

get '/' do
  @posts = Post.all
  erb :index
end

get '/search' do
  @search = Search.for params[:q]
  erb :search
end

get '/:id' do
  @post = Post.find params[:id]
  erb :post
end

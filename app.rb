require 'sinatra'
require './Post'
require './Search'

get '/' do
  @posts = Post.list
  @paginate = 0
  erb :index
end

get '/p/:num' do
  @paginate = params[:num].to_i
  @posts = Post.list paginate: @paginate
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

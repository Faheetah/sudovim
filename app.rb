require 'sinatra'
require './Post'
require './Search'

before '/*' do
  @query = params[:q].split(' ') if params[:q].is_a? String
  @paginate = params[:p].to_i
end

get '/' do
  @posts = Post.all paginate: @paginate
  erb :index
end

get '/search' do
  @search = Search.for @query
  erb :search
end

get '/:id' do
  @post = Post.find params[:id]
  erb :post
end

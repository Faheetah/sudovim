require 'sinatra'
require './Post'
require './Search'

before '/*' do
  @query = params[:q].split('+')
  @paginate = params[:p].to_i
end

get '/' do
  @posts = Post.list paginate: @paginate
  #@paginate = 0
  erb :index
end

#get '/p/:num' do
#  @paginate = params[:num].to_i
#  @posts = Post.list paginate: @paginate
#  erb :index
#end

get '/search' do
  @search = Search.for @query
  erb :search
end

get '/:id' do
  @post = Post.find params[:id]
  erb :post
end

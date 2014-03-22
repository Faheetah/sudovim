require 'sinatra'
require 'sequel'
require './Post'
require './Tag'
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

get '/tag/*' do
p params
  @query = Search.tags params[:splat].first.split '/'
  @results = Post.find(@query.flat_map(&:values))
  erb :search
end

get '/:id*' do
  @post = Post.find(params[:id])[0]
  @tags = Tag.find params[:id]
  erb :post
end

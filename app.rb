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
  @posts = Search.find @query, paginate: @paginate
  erb :index
end

get '/tag/*' do
  @query = params[:splat].first.gsub('#','%23').split '/'
  @search = Search.tags(@query).flat_map(&:values)
  @posts = Post.find @search, paginate: @paginate
  erb :index
end

get '/:id*' do
  @post = Post.find(params[:id].to_i)
  if @post
    @post[:tags] = Tag.find params[:id].to_i
    erb :post
  else
    redirect '/'
  end
end

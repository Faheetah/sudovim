require 'sinatra'
require 'sequel'
require './Post'
require './Tag'
require './Search'

before '/*' do
  @query = params[:q].split(' ') if params[:q].is_a? String
  @paginate = params[:p].to_i
end

#after '/*' do
#  pass if request.path_info == '/'
#  if not @posts
#    redirect '/'
#  end
#end

get '/' do
  @posts = Post.all paginate: @paginate
  erb :index
end

get '/search' do
  @posts = Search.find @query
  erb :index
end

get '/tag/*' do
  @query = params[:splat].first.split '/'
  @search = Search.tags(@query).flat_map(&:values)
  @posts = Post.find @search, paginate: @paginate
  erb :index
end

get '/:id*' do
  @post = Post.find(params[:id])[0]
  @tags = Tag.find params[:id]
  erb :post
end

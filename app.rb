require 'sinatra'
require 'sequel'
require 'redcarpet'
require './Post'
require './Tag'
require './Search'

use Rack::Session::Cookie, :key => 'auth', :domain => 'localhost', :path => '/new',
      :expire_after => 2592000, :secret => '8rj3289rj9foeawhf98o4haf8493oafhaw8ehufizlhfg78oh8'

## General routing

before '/*' do
  @paginate = params[:p].to_i
  @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(no_links: true, hard_wrap: true, prettify: true),
                extensions = {fenced_code_blocks: true, no_intra_emphasis: true,
                superscript: true, strikethrough: true})
end

get '/' do
  @posts = Post.all paginate: @paginate
  erb :index
end

get '/search' do
  @query = params[:q].split(' ') if params[:q].is_a? String
  @search = Search.find(@query).flat_map(&:values)
  @posts = Post.find @search, paginate: @paginate
  erb :index
end

get '/tag/*' do
  @query = params[:splat].first.gsub('#','%23').split '/'
  @search = Search.tags(@query).flat_map(&:values)
  @posts = Post.find @search, paginate: @paginate
  erb :index
end

get '/about' do
  erb :about
end

get '/tools' do
  erb :tools
end

## Authentication and new post

get '/new' do
  if session[:login] == 'true'
    erb :new
  else
    erb :login
  end
end

post '/new' do
  if session[:login] == 'true'
    if params['preview']
      erb :new
    elsif params['submit']
      @post = Post.new title: params[:title], summary: params[:summary], content: params[:content], tags: params[:tags]
      redirect '/'+@post.to_s
    end
  else
    erb :login
  end
end

post '/login' do
  if params[:username] == 'main' && params[:password] == 'w7e9f8j'
    session[:login] = 'true'
    redirect '/new'
  else
    redirect '/'
  end
end

get '/logout' do
  session.clear
  redirect '/new'
end

## Get ID

get '/:id*' do
  @post = Post.find(params[:id].to_i)
  if @post
    @post[:tags] = Tag.find params[:id].to_i
    erb :post
  else
    redirect '/'
  end
end

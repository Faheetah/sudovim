require 'sinatra'
require 'sequel'
require 'redcarpet'
require './Post'
require './Tag'
require './Search'

use Rack::Session::Cookie, :key => 'auth', :domain => 'localhost', :path => '/new', :expire_after => 2592000, :secret => '8rj3289rj9foeawhf98o4haf8493oafhaw8ehufizlhfg78oh8'

before '/*' do
  @paginate = params[:p].to_i
  @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(fenced_code_blocks: true, no_links: true, hard_wrap: true), extensions = {no_intra_emphasis: true, superscript: true, strikethrough: true, prettify: true})
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
  if params[:username] != '' or params[:password]
    redirect '/'
  elsif params[:auth] == (DateTime.now.strftime('%-Y%-j').to_i ** DateTime.now.strftime('%-w%-l').to_i).to_s(16)
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

get '/:id*' do
  @post = Post.find(params[:id].to_i)
  if @post
    @post[:tags] = Tag.find params[:id].to_i
    erb :post
  else
    redirect '/'
  end
end

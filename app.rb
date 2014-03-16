require 'sinatra'

get '/' do
  '/'
end

get '/search' do
  params[:q]
end

get '/:date/:slug' do
  p params[:date] + params[:slug]
end

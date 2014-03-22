require 'sequel'

DB = Sequel.postgres('sudovim', :user => 'sudovim', :password => 'sudovim', :host => 'localhost')

DB.create_table! :posts do
  primary_key :id
  String :title
  String :slug
  String :content, :text => true
  String :tags
  Date :date
end

DB.create_table! :tags do
  primary_key :id
  foreign_key :posts_id, :posts
  String :tag
end

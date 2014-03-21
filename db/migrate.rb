require 'sequel'

DB = Sequel.postgres('sudovim', :user => 'sudovim', :password => 'sudovim', :host => 'localhost')

DB.create_table :posts do
  primary_key :id
  String :title
  String :slug
  String :content, :text => true
  String :tags
  Date :date
end

#!/usr/bin/env ruby

require 'sequel'
require './Post'
require './Tag'
require './test/sample'

Sequel.postgres('sudovim', :user => 'sudovim', :password => 'sudovim', :host => 'localhost').run "DELETE FROM tags"
Sequel.postgres('sudovim', :user => 'sudovim', :password => 'sudovim', :host => 'localhost').run "DELETE FROM posts"

describe Post do
  before :all do
    @data = Sample.load

  end


  describe '#new' do

    it 'creates twenty entries' do
      @data.each do |entry|
        expect(Post.new title: entry[:title], summary: entry[:summary], content: entry[:content], tags: entry[:tags], date: entry[:date]).to be >= 1
      end
      expect(Post.all(length:100).length).to be == @data.length
    end

  end


  describe '#all' do

    it 'lists ten values' do
      expect(Post.all.length).to eq 10
    end

    it 'matches the first entry title' do
      expect(Post.all[0][:title]).to eq @data.reverse[0][:title]
    end

    it 'matches the last entry title' do
      expect(Post.all[9][:title]).to eq @data.reverse[9][:title]
    end

    it 'paginates' do
      expect(Post.all(paginate: 10).length).to eq 10
    end

    it 'paginates correctly' do
      expect(Post.all(paginate: 10)[0][:title]).to eq @data.reverse[10][:title]
      expect(Post.all(paginate: 20)[0][:title]).to eq @data.reverse[20][:title]
    end

  end

  describe '#find' do

    it 'isn\'t implemented yet' do
    end

  end

end


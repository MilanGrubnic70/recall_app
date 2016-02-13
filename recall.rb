require "rubygems"
require "sinatra"
require "datamapper"

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/recall.db") # set up database in currrent directory

class Note # create table
	include DataMapper::Resource
	property :id, Serial # auto-incrementing key
	property :content, Text, :required => true
	property :complete, Boolean, :required => true, :default => false
	property :created_at, DateTime
	property :updated_at, DateTime
end

DataMapper.finalize.auto_upgrade! #automatically update database after changes

get '/' do
	@notes = Note.all.order => :id.desc
	@title = "All Notes"
	erb :home
end
require "sinatra"
require "data_mapper"
require "rack-flash"
require "sinatra/redirect_with_flash"

enable :sessions
use rack::Flash, :sweep => true

SITE_TITLE = "Recall"
SITE_DESCRIPTION = "'cause you're to busy to remember"

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

helpers do
	include Rack::Utils
	alias_method :h, :escape_html
end

get '/' do
	@notes = Note.all :order => :id.desc
	@title = "All Notes"
	if @notes.empty?
		flash[:error] = 'No notes found. Add your first note below.'
	end
	erb :home
end

post '/' do
	n = Note.new
	n.content = params[:content]
	n.created_at = Time.now
	n.updated_at = Time.now
	n.save
	redirect '/'
end

get '/rss.xml' do
	@notes = Note.all :order => :id.desc
	builder :rss
end

get '/:id' do
	@note = Note.get params[:id]
	@title = "Edit note #{params[:id]}"
	erb :edit
end

put '/:id' do
	n = Note.get params[:id]
	n.content = params[:content]
	n.complete = params[:complete] ? 1 : 0
	n.updated_at = Time.now
	n.save
	redirect '/'
end

get '/:id/delete' do
	@note = Note.get params[:id]
	@title = "Confirm deletion of note #{params[:id]}"
	erb :delete
end

delete '/:id' do
	n = Note.get params[:id]
	n.destroy
	redirect '/'
end

get '/:id/complete' do
	n = Note.get params[:id]
	n.complete = n.complete ? 0 : 1
	n.updated_at = Time.now
	n.save
	redirect '/'
end

require 'sinatra'
require 'sinatra/reloader' if development?
require 'pry-byebug'
require 'better_errors'
require 'sqlite3'

# added these
require 'sinatra/activerecord'
require 'rest-client'

set :database, { adapter: 'sqlite3', database: 'foo.sqlite3' }
# El nombre de la DB cuando la creo con rake db:create
# es el nombre que aparece arriba ("foo.sqlite3")

class Post < ActiveRecord::Base
end

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path(__dir__)
end

# DB = SQLite3::Database.new(File.join(File.dirname(__FILE__)))

get '/' do
  @posts = Post.all.order(votes: :desc)
  erb :posts
end

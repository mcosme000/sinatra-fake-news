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

get '/add-post' do
  erb :add_post
end

# The route I write here MUST BE THE SAME
# that I add on the form action attr.
put '/posts/:id/upvote' do
  post = Post.find(params[:id])
  post.votes += 1
  post.save

  redirect to('/')
end

post '/posts' do
  post = Post.new
  post.title = params[:title]
  post.save

  redirect to('/')
end

get '/posts/:id/delete' do
  post = Post.find(params[:id])
  post.destroy
  @posts = Post.all.order(votes: :desc)
  redirect to('/')
end

# Post upvote
# put '/posts/:id/upvote' do
#   post = Post.find(params[:id])
#   post.votes += 1
#   post.save

#   redirect to('/')
# end

require 'json'
require 'rest-client'

# TODO: Write a seed to insert 10 posts in the database fetched from the Hacker News API.

serialized = RestClient.get('https://hacker-news.firebaseio.com/v0/topstories.json')
numbers = JSON.parse(serialized).sample(10)

10.times do
  response = RestClient.get("https://hacker-news.firebaseio.com/v0/item/#{numbers.sample(1).first}.json")
  data = JSON.parse(response)
  post = Post.create(title: data['title'], url: data['url'], votes: data['score'])
  post.save
end

require 'redis'
require 'json'

redis = Redis.new(host: "localhost", port: "6379")
redis.set :hello, "Hello World"
p redis.get :hello

redis.set :foo, [1, 2, 3].to_json
puts JSON.parse(redis.get("foo")).class

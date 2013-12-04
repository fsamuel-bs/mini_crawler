require 'sinatra'
require 'redis'

get '/' do
  erb :index
end

get '/results' do
  @search_text = params[:search_text]
  @results = parse(@search_text)
  erb :results
end

def parse(search_text)
  @word = search_text
  @redis = Redis.new(host: "localhost", port: "6379")
  p @word

  results = @redis.zrevrange("#{@word}_tf_idf", 0, 10, {withscores: true})
  p results
  @results = results.map do |link, score|
    p link
    {title: @redis.hget(link, :_title), link: link}
  end

  scores = scores.sort_by { |link, score| score }.reverse

  @results = scores.map do |link, score|
    {title: titles[link], link: link}
  end
end

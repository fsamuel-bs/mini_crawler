class TF_IDF
  require 'redis'

  def initialize
    @redis = Redis.new(host: "localhost", port: "6379")
  end

  def calculate_tf_idf(i)
    word = @redis.lindex(:_words, i)
    n_pages_with_word = @redis.hlen(word)
    pages_with_word = @redis.hgetall(word)
    n_pages = @redis.llen(:_urls)

    idf = Math.log(n_pages / (n_pages_with_word + 1.0)) / Math.log(10)

    pages_with_word.each do |page, n_word_in_page|
      tf = (n_word_in_page.to_i <= 50) ? n_word_in_page.to_i : 0
      @redis.zadd("#{word}_tf_idf", tf * idf, page)
    end
  end

  def main
    n_words = @redis.llen(:_words)
    n_words.times do |i|
      calculate_tf_idf i
    end
  end
end

tf_idf = TF_IDF.new
tf_idf.main


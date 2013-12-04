require 'open-uri'
require 'nokogiri'
require 'redis'
require 'json'

class Crawler

  class Nokogiri::HTML::Document
    def parse_text
      self.xpath('html/body/div/section/div/article/section/section/p[not(@align)]').map(&:content)
    end

    def parse_title
      self.xpath('html/body/div/section/div/article/section/header/h1')[0].content
    end

    def parse_links
      self.xpath('html/body/div/section/div/article/section/section/p[not(@align)]//a').map { |link| link[:href] }
    end

    def parse_next_page
      next_page_tag = self.xpath('html/body/div/section/div/article/section/nav/ul/li/a')[1]
      next_page_tag ? next_page_tag[:href] : next_page_tag
    end
  end

  def initialize
    @redis = Redis.new(host: "localhost", port: "6379")
  end

  def main
    while(true)
      persist if parse
      clean
    end
  end

  def persist
    persist_values
    persist_next_links
    persist_url_and_words
  end

  def clean
    @url = nil
    @title = nil
    @links = nil
    @words = nil
  end

  def parse
    @url = @redis.lpop(:_url_list_todo)
    return false if url_done?
    @redis.hset(:_url_list_done, @url, 1)

    p @url

    doc = Nokogiri::HTML(open(@url))

    @title = doc.parse_title
    text = doc.parse_text
    @links = doc.parse_links
    next_page = doc.parse_next_page

    page = @url
    while (next_page && next_page.split('-')[0] == page.split('-')[0]) do
      page = next_page
      doc = Nokogiri::HTML(open(page))

      text += doc.parse_text
      @links += doc.parse_links
      next_page = doc.parse_next_page
    end

    text2 = text.map(&:downcase)

    text3 = text2.map do |p|
      p2 = p.gsub(/[,:;?!]/, '')
      p2.gsub!(/\"/, ' ')
      p2.gsub!(/"#&@%<>/, '')
      p2.gsub!(/[\[\]{}()]/, '')
      p2.gsub!(/[\/\-\\+=|]/, ' ')
      p2.gsub!(/([a-z0-9])[.]/, '\1')
      p2.gsub(/[.]/, ' ')
      p2.gsub!(/[...]/, '')
      p2.gsub!(/[ ]'[ ]/, '  ')
      p2.gsub!(/å¤§é�ª/, '')
      p2.gsub!(/$([^a-z0-9])/, '\1')
      p2
    end

    @words = text3.join(" ").split(" ").group_by { |i| i }.map { |k, v| [k, v.length] }
    return true
  end

  private
  def persist_values
    @redis.hmset(@url, :_links, @links.to_json, :_title, @title)

    @words.each do |word, n_word|
      @redis.hset(word, @url, n_word)
    end
  end

  def persist_next_links
    return unless @links != nil && !@links.empty? && @links.instance_of?(Array)

    @links.select! do |link|
      if link # && (link.split('.').last == 'html')
        link_splitted = link.split('/')
        # Parse link splitted according to html chosen
      end
    end

    @links.map! do |link|
      if link && (link[0, 3] == '%20')
        link = link[3, link.length - 3]
      else
        link
      end

      # if link.split('/').last.split('_').last == 'p2'
    end

    if (@links != nil && !@links.empty?)
      @redis.rpush(:_url_list_todo, @links)
    end
  end

  def persist_url_and_words
    @redis.rpush(:_urls, @url)

    @words.each do |word, n_word|
      if @redis.hget(:_word_count, word)
        old_n_word = @redis.hget(:_word_count, word).to_i
        @redis.hset(:_word_count, word, old_n_word + n_word)
      else
        @redis.hset(:_word_count, word, n_word)
        @redis.rpush(:_words, word)
      end
    end
  end

  def url_done?
    @redis.hget(:_url_list_done, @url)
  end
end

c = Crawler.new
c.main


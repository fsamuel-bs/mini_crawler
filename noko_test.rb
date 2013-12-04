require 'open-uri'
require 'nokogiri'

# TEST1:
doc = Nokogiri::HTML(open("http://www.cracked.com/article_20715_6-priceless-ancient-artifacts-destroyed-by-idiots.html"))

<<TEST2
doc = Nokogiri::HTML.parse(<<-eohtml)
<html>
  <head>
    <title>Hello World</title>
    <a>
      bleh
    </a>
    <p>
      blah
    </p>
  </head>
  <body>
    <h1>This is an awesome document</h1>
    <p>
      I am a paragraph
      <a href="http://google.com">I am a link</a>
    </p>
  </body>
</html>
eohtml
<<<<<<< HEAD
TEST2

doc.xpath('html/body/p/a').each do |tag|
    puts tag.class
    puts tag[:href]
end

# name of article (string)
# .xpath('html/body/div/section/div/article/section/header/h1').each { |tag| p tag.content }

# name of authors (array)
# .xpath('html/body/div/section/div/article/section/footer/div/a').each { |tag| p tag.content }

# subtitles
# .xpath('html/body/div/section/div/article/section/section/h2').each { |tag| p tag.content }

# text
# .xpath('html/body/div/section/div/article/section/section/p[not(@align)]').each { |tag| p tag.content }

# other links
# .xpath('html/body/div/section/div/article/section/section/p[not(@align)]/a').each { |tag| p tag[:href] }

# next page link
# .xpath('html/body/div/section/div/article/section/nav/ul/li/a')[1][:href]
#

# filter:
# text2.map do |p|
#   p2 = p.gsub(/[,"();?!]|\"/, '')   # eliminating every kind of punctuation
#   p2.gsub!(/[\/\-\\]/, ' ')         # trade /, -, \ for spaces
#   p2.gsub!(/([a-z0-9])[.]/, '\1')   # eliminate . before words
#   p2.gsub!(/[.]/, ' ')              # words with . in the middle or at the start (unlikely) become new words
#   p2.gsub!(/[...]/, '')             # eliminate suspension points
#   p2.gsub!(/([ ])'([ ])/, '  '); p2 # eliminate ' at the middle of sentences
# end
#
#


# if optimization needed
# .xpath('//div[@class="module article dropShadowBottomCurved"]').each { |tag| p tag.content }

# doc.xpath('html').each do |a_tag|
#     puts a_tag.content
# end

# doc.xpath('//p').each do |a_tag|
#     puts a_tag.content
# end

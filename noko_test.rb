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
TEST2

doc.xpath('html/body/p/a').each do |a_tag|
    puts a_tag.content
end

doc.xpath('html').each do |a_tag|
    puts a_tag.content
end

# doc.xpath('//p').each do |a_tag|
#     puts a_tag.content
# end

#-- encoding: UTF-8
require 'nokogiri'
require 'open-uri'

# See https://github.com/sparklemotion/nokogiri for samples like below
# Get a Nokogiri::HTML::Document for the page we’re interested in...
doc = Nokogiri::HTML(open('http://news.baidu.com/ns?word=%E5%A5%BD%E5%A3%B0%E9%9F%B3%20-%28%E8%B5%B5%E8%96%87%29&pn=100&cl=2&ct=0&tn=newsdy&rn=20&ie=utf-8&bt=1388332800&et=1388505599'))

# Search for nodes by xpath
doc.search('//div/ul/li').each do |item|
  puts "found one item, now processing "
  # puts item.content
  item.search('.//h3/a').each do |link|
    puts "Url: " + link['href']
    puts "Title: " + link.content
  end

  # regular expression??
  item.css('span').each do |author_time|
    content = author_time.content.strip;
    #puts "Author and time : " + content
    date_len = "2013-12-30 09:27:00".length
    if content.length < date_len
      site = content
      time = ""
    else
      time = content[(0-date_len)..-1]
      site = content[0, (content.length - date_len)]
    end
    puts "Site: " + site
    puts "Time: " + time
  end

  puts "end of item \n\n\n"
end

doc.search('//div/div/p/a').each do |item|
  puts item.content
  if '下一页>' == item.content
        next_page = item['href']
        puts "next page url:" + item['href']
  end
end

# ####
# # Or mix and match.
# doc.search('h3.r a.l', '//h3/a').each do |link|
#   puts link.content
# end
require 'nokogiri'
require 'open-uri'

# See https://github.com/sparklemotion/nokogiri for samples like below
# Get a Nokogiri::HTML::Document for the page we’re interested in...
doc = Nokogiri::HTML(open('http://news.baidu.com/ns?ct=1&rn=20&ie=utf-8&bs=%E5%A5%BD%E5%A3%B0%E9%9F%B3+-%28%E8%B5%B5%E8%96%87%29&rsv_bp=1&sr=0&cl=2&f=8&prevct=no&word=%E5%A5%BD%E5%A3%B0%E9%9F%B3+-%28%E8%B5%B5%E8%96%87%29&tn=news&inputT=0'))

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

  ## summary 
  #item.css('div').each do |summary|
  #  puts summary.content
  #end
  puts "end of item \n\n\n"
end

# ####
# # Or mix and match.
# doc.search('h3.r a.l', '//h3/a').each do |link|
#   puts link.content
# end
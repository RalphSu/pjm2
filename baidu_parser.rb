#-- encoding: UTF-8
require 'nokogiri'
require 'open-uri'
require 'uri'

# See https://github.com/sparklemotion/nokogiri for samples like below
# Get a Nokogiri::HTML::Document for the page we’re interested in...
"http://news.baidu.com/ns?word=%E5%A5%BD%E5%A3%B0%E9%9F%B3%20-%28%E8%B5%B5%E8%96%87%29&pn=20&cl=1&ct=1&tn=news&rn=20&ie=utf-8&bt=0&et=0&rsv_page=0"
news = 'news'
last_day = Time.now - (60 * 60 * 24)
today = Time.now
start_time = Time.new(last_day.year, last_day.month, last_day.day)
end_time = Time.new(today.year, today.month, today.day)
bt = start_time.to_i
y0 = start_time.year
m0 = start_time.month
d0 = start_time.day
y1 = end_time.year
m1 = end_time.month
d1 = end_time.day
begin_date = start_time.strftime('%Y-%m-%d')
end_date = end_time.strftime('%Y-%m-%d')
et = end_time.to_i
cl = 2
ct1 = 1
ct = 1
q1 = URI.encode('好声音')
q4 = URI.encode('赵薇')
tn = 'newsdy'
rn = 20
map = {
  :tn => 'newsdy',
  :q4 => URI.encode('赵薇'),
  :from => 'news',
  :start_time => (Time.now - (60 * 60 * 24)),
  :end_time => Time.now,
  :bt => start_time.to_i,
  :y0 => start_time.year,
  :m0 => start_time.month,
  :d0 => start_time.day,
  :y1 => end_time.year,
  :m1 => end_time.month,
  :d1 => end_time.day,
  :begin_date => start_time.strftime('%Y-%m-%d'),
  :end_date => end_time.strftime('%Y-%m-%d'),
  :et => end_time.to_i,
  :cl => 2,
  :ct1 => 1,
  :ct => 1,
  :q1 => URI.encode('好声音'),
  :q4 => URI.encode('赵薇'),
  :tn => 'newsdy',
  :rn => 20
}

# puts map.to_s

url = "http://news.baidu.com/ns?from=#{news}&bt=#{bt}&y0=#{y0}&m0=#{m0}&d0=#{d0}&y1=#{y1}&m1=#{m1}&d1=#{d1}&cl=#{cl}&et=#{et}&ct1=#{ct1}&ct=#{ct}&q1=#{q1}&q4=#{q4}&tn=#{tn}&rn=#{rn}&begin_date=#{begin_date}&end_date=#{end_date}"
puts url
doc = Nokogiri::HTML(open(url))

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

def multi()
  [:a.to_s, :b.to_s]
end

b = multi
puts b[0]
puts b[1]
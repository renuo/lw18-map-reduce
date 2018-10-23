#!/usr/bin/env ruby
require 'open-uri'
require 'nokogiri'

sitemap_text = open('https://www.renuo.ch/sitemap.xml').read
sitemap_doc = Nokogiri::XML(sitemap_text)
sitemap_doc.remove_namespaces!

renuo_urls = sitemap_doc.xpath('/urlset/url/loc').map(&:content)
renuo_de_urls = renuo_urls.select { |url| url.include?('/de/') }

word_count = {}
renuo_de_urls.each do |url|
  page_html = Nokogiri::HTML(open(url).read)
  page_text = page_html.text.gsub!(/\W/,' ')
  page_text.each_line do |line|
    words = line.split.compact
    words.each do |word|
      if word_count.key?(word)
        word_count[word] += 1
      else
        word_count[word] = 1
      end
    end
  end
rescue OpenURI::HTTPError => e
  puts e.message
end

puts 'Counted everything:'
puts word_count

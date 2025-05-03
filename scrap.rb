#!/usr/bin/env ruby

require "nokogiri"
require "open-uri"
require "set"

page = 1
File.open('input.txt', 'w') do |file|
  loop do
    followers = "https://github.com/Gorillq?page=#{page}&tab=followers"
    foll = Nokogiri::HTML(URI.open(followers))
    spans = foll.css('span.Link--secondary.pl-1')
    spans.each do |span|
      file.puts(span.text.strip)
    end
    next_page = foll.at_css('a[rel="nofollow"]')
    break unless next_page
    page += 1
  end
end

page = 1
File.open('output.txt', 'w') do |file|
  loop do
    following = "https://github.com/Gorillq?page=#{page}&tab=following"
    fill = Nokogiri::HTML(URI.open(following))
    spans = fill.css('span.Link--secondary.pl-1')
    spans.each do |span|
      file.puts(span.text.strip)
    end
    next_page = fill.at_css('a[rel="nofollow"]')
    break unless next_page
    page += 1
  end
end

users_followed = Set.new(File.readlines('input.txt').map(&:strip).reject(&:empty?))
users_following = Set.new(File.readlines('output.txt').map(&:strip).reject(&:empty?))
unique = (users_followed - users_following) + (users_following - users_followed)

File.write('result.txt', unique.to_a.join("\n"))
puts "Done!"

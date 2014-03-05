#!/usr/bin/env ruby

# Parse markdown README files to get image attributes.

require 'maruku'
require 'find'
require 'pathname'
require 'nokogiri'

files = []

Find.find('../images/') do |path|
  files << path if path =~ /README.md/
end

files.each do |file|
  page = Nokogiri::HTML::Document.parse(Maruku.new(File.read(file)).to_html)
  title = page.at_css "h1"
  puts title.content
end

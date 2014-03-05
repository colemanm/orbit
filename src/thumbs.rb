#!/usr/bin/env ruby

# This script generates thumbnail images from source iPad wallpaper files.

require 'rmagick'
require 'find'
require 'pathname'

files = []
thumbs_dir = '../thumbs'

Find.find('../images/') do |path|
  files << path if path =~ /ipad-.*\.jpg$/
end

files.each do |file|
  path = Pathname.new(file)
  filename = path.basename.to_s.sub(/ipad-/, '').sub(/.jpg$/, '')

  img = Magick::Image::read(file).first
  thumb = img.resize_to_fill(250,200)
  thumb.write "#{thumbs_dir}/#{filename}.jpg"

  puts "#{filename}.jpg generated."
end

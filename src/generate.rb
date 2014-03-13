#!/usr/bin/env ruby

require 'thor'
require 'haml'
require 'maruku'
require 'find'
require 'pathname'
require 'nokogiri'

class Orbit < Thor

  desc "site", "Generate main index page and subpages."
  def site
    files = Dir.glob('../thumbs/*')
    files.each { |file| file.sub!(/../, '') }

    index_content = "---\nlayout: default\n---\n\n"

    files.each do |file|
      index_content << "<div class='image'><a href='place/#{basename(file)}/'><img src='thumbs/#{basename(file)}.jpg' /></a></div>\n"
    end

    File.open("../index.html", "wt") do |f|
      f.write(index_content)
    end

    files.each do |file|
      loc = basename(file)
      path = "../place/#{loc}/"

      FileUtils.mkdir_p(path) unless File.directory?(path)
      File.open("#{path}index.html", "wt") do |f|
        place_content = "---\nlayout: detail\n---\n\n"
        place_content <<
"<div>
  <img class='screenshot' src='../../images/#{loc}/screenshot.jpg' />
  <p class='title'>#{parse_title(loc)}</p>
  <p class='description'>#{parse_description(loc)}</p>
  <ul class='downloads'>
    <li><a href='../../images/#{loc}/iphone5-#{loc}.jpg'>iPhone 5</a></li> <span class='bullet'>&bull;</span>
    <li><a href='../../images/#{loc}/iphone4-#{loc}.jpg'>iPhone 4</a></li> <span class='bullet'>&bull;</span>
    <li><a href='../../images/#{loc}/ipad-#{loc}.jpg'>iPad</a></li>
  </ul>
</div>"
        f.write(place_content)
      end
    end
  end

  no_tasks do

    def parse_title(dir)
      page = Nokogiri::HTML::Document.parse(Maruku.new(File.read("../images/#{dir}/README.md")).to_html)
      title = page.at_css "h1"
      title.content
    end

    def parse_description(dir)
      page = Nokogiri::HTML::Document.parse(Maruku.new(File.read("../images/#{dir}/README.md")).to_html)
      description = page.at_css "p"
      description.content
    end

    def basename(file)
      File.basename(file, ".*")
    end

  end

end

Orbit.start

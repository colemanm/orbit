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
      index_content << "<div class='image'><a href='place/#{basename(file)}/'><img src='#{file}' /></a></div>\n"
    end

    File.open("../index.html", "wt") do |f|
      f.write(index_content)
    end

    files.each do |file|
      path = "../place/#{basename(file)}/"

      FileUtils.mkdir_p(path) unless File.directory?(path)
      File.open("#{path}index.html", "wt") do |f|
        place_content = "---\nlayout: default\n---\n\n"
        place_content <<
"<div>
  <img src='/images/#{basename(file)}/screenshot.jpg' />
  <ul class='downloads'>
    <li>iPhone 5</li>
    <li>iPhone 4</li>
    <li>iPad</li>
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

    def generate_page(title)

    end

    def basename(file)
      File.basename(file, ".*")
    end

  end

end

Orbit.start

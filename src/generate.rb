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
    files = Dir.glob('../images/thumbs/*')
    files.each { |file| file.sub!(/../, '') }

    content = "---\nlayout: default\n---\n\n"
    files.each do |file|
      puts file
      content << "<div class='image'><a href='place/'><img src='#{file}' /></a></div>\n"
    end

    # File.open("../index.html", "wt") do |f|
    #   f.write(content)
    # end

    puts parse_title("glaciers")
  end

  no_tasks do

    def parse_title(dir)
      page = Nokogiri::HTML::Document.parse(Maruku.new(File.read("../images/#{dir}/README.md")).to_html)
      title = page.at_css "h1"
      title.content
    end

    def generate_page(title)

    end

  end

end

Orbit.start

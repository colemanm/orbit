#!/usr/bin/env ruby

require 'thor'
require 'haml'

class Orbit < Thor

  desc "site", "Generate main index page and subpages."
  def site
    files = Dir.glob('../images/thumbs/*')
    files.each { |file| file.sub!(/../, '') }

    content = "---\nlayout: default\n---\n\n"
    files.each do |file|
      content << "<div class='image'><img src='#{file}' /></div>\n"
    end

    puts content

    File.open("../index.html", "wt") do |f|
      f.write(content)
    end
  end

end

Orbit.start

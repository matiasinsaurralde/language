#!/usr/bin/env ruby
# encoding: utf-8

# quick script for extracting texts from downloaded wikipedia articles #

begin

	require 'nokogiri'

rescue LoadError

	puts 'looks like you don\'t have nokogiri :('

	exit()

end

files, articles, total_paragraphs, total_words = Dir[ File.join( ARGV[0], '*' ) ], {}, 0, 0

files.each do |article|

	article_name = File.basename( article )

	articles.store( article_name, [] )

	html = Nokogiri::HTML( File.read(article) )

	html.css('p').each do |paragraph|

		articles[article_name] << paragraph.text

		total_paragraphs += 1

		total_words += paragraph.text.split.size

	end

end


puts "--- total articles: #{articles.size}, paragraphs: #{total_paragraphs}, words: #{total_words}"

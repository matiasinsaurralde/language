#!/usr/bin/env ruby
# encoding: utf-8

require 'oj'
require './language'

include Language

Oj.load( File.read('../archive2/29-03-2013.json').downcase ).each do |tid, tweet|
	begin
		puts "@#{tweet[:screen_name]}: #{tweet[:p]}"
		tweet[:p].split().grep(/^@/).each do |mention|
			tweet[:p].gsub!(mention, '')
		end
		tweet[:p].split().grep(/^http:/) do |url|
			tweet[:p].gsub!(url, '')
		end
		s = Text.new( tweet[:p] )
		pp s.language_detection().first
		pp s.splitted_language_detection().first
		x = gets
	rescue
	end
end


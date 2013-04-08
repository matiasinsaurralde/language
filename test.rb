#!/usr/bin/env ruby
# encoding: utf-8

require './language'

include Language

t = gets.chomp.to_s

example = Text.new ( t )

puts "language_detection(): #{example.language_detection().inspect}"

#puts "language_detection(split): #{example.splitted_language_detection().inspect}"

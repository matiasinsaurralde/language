#!/usr/bin/env ruby
# encoding: utf-8

require './language'

include Language

example = "texto de prueba"

puts "#{example}:"
text = Text.new(example)

pp text.language_detection()

puts

pp text.splitted_language_detection()

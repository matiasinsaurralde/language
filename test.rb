#!/usr/bin/env ruby
# encoding: utf-8

require './language'

include Language

example = "chupe al instante capto mi maldad @emmxnuelsegovia jajaja despues ya no me callaba yo"

puts "#{example}:"
text = Text.new(example)

pp text.language_detection()

puts

pp text.splitted_language_detection()

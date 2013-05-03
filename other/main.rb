#!/usr/bin/env ruby
# encoding: utf-8

require './context'

context = Context.new()

Dir['samples/*.txt'].each do |f|
	context << Text.new( File.read(f) )
end

context.update_frequency()
pp context.global_frequency()

#!/usr/bin/env ruby
# encoding: utf-8

require './context'

t = Text.new( File.read('samples/1.txt') )

pp t.terms()

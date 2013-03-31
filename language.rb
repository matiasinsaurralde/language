#!/usr/bin/env ruby
# encoding: utf-8

require 'pp'

module Language

	class Definition

		@@available_definitions = []

		attr_reader :name, :options

		def initialize(name, options)

			@name, @options, @magnitude = name, options, Maths::magnitude( options[:letter_frequency] )

			@@available_definitions << self

		end

		def match(text)

			available_letters = {}

			@options[:letter_frequency].each do |letter, weight|
				if text.letter_freq[letter]
					available_letters.store( letter, weight )
				end
			end

			dot_product = Maths::dotp( available_letters, text.letter_freq )

			magnitude_p = Maths::magnitude_product( @magnitude, text.magnitude )

			return Maths::similarity( dot_product, magnitude_p )

			
		end

		def self.available_definitions()
			@@available_definitions
		end

		def self.load_all()
			Dir['definitions/*.def'].each do |f|
				name = File.basename(f).gsub('.def', '')
				options = {}
				File.read(f).split("\n").each do |line|
					splits = line.split(' ')
					key = splits[0].to_sym
					value = eval( splits[1, splits.size].join('') )
					options.store(key, value)
				end
				Definition.new(name.to_sym, options)
				#puts name
				#pp options[:letter_frequency].sort_by {|k,v| v}.reverse
				#puts
			end
		end

	end

	class Text

		attr_reader :body, :letter_freq, :magnitude

		def initialize(body)

			@body, @letter_freq = body, Maths::letter_freq(body)

			@magnitude = Maths::magnitude(@letter_freq)

		end

		def splitted_language_detection()

			results, ordered_results, splits = {}, {}, @body.split()

			splits.each do |split|

				Text.new(split).language_detection().each do |language, percentage|

					if results[language]

						results[language] << percentage

					else

						results.store(language, [ percentage ])

					end

				end

			end

			results.each do |language, percentages|
				results[language] = ( percentages.inject(:+) / splits.size ).round(2)
			end

			results.sort_by {|l,p| p}.reverse.each do |a|; ordered_results.store(a[0], a[1]); end

			return ordered_results

		end

		def language_detection()

			matches, ordered_matches = {}, {}

			Definition::available_definitions.each do |language|
				matches.store(language.name, language.match( self ))
			end

			matches.sort_by {|l,s| s }.reverse.each do |a|; ordered_matches.store(a[0], a[1]); end

			return ordered_matches
		end

	end

	module Maths

		def self.letter_freq(s)

			letters, sorted_letters, letters_count = {}, {}, 0

			s.split(//).each do |letter|

				if letters[letter]

					letters[letter] += 1

				else

					letters.store(letter, 1)

				end

				letters_count += 1

			end

			[' ', ',', '.', ':', '?', '!', '"'].each do |n|

				letters.delete(n) if letters[n]

			end

			letters.sort_by {|l,c| l}.each do |a|
				sorted_letters.store( a[0], ( a[1].to_f / letters_count.to_f * 100.0 ).round(2) )
			end

			return sorted_letters

		end

		def self.dotp(v1, v2)

			dot_product = []

			v1.values.zip(v2.values).each do |p|

				dot_product << ( p[0]*p[1] )

			end

			dot_product.inject(:+)

		end

		def self.magnitude(v)

			m = []

			v.values.each do |n|

				m << n**2

			end

			return m.inject(:+)

		end

		def self.magnitude_product(m1, m2)
			return Math.sqrt( m1 * m2 )
		end

		def self.similarity(dotp, magnitude_p)
			n = ( dotp / magnitude_p ) * 100.0
			return n.round(2)
		end

	end

end

Language::Definition.load_all()

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
			Dir['definitions/*'].each do |f|
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

#Language::Definition.new(:spanish, :letter_frequency => {"a"=>11.72, "b"=>1.49, "c"=>3.87, "d"=>4.67, "e"=>13.72, "f"=>0.69, "g"=>1.0, "h"=>1.18, "i"=>5.28, "j"=>0.52, "k"=>0.11, "l"=>5.24, "m"=>3.08, "n"=>6.83, "o"=>8.44, "p"=>2.89, "q"=>1.11, "r"=>6.41, "s"=>7.2, "t"=>4.6, "u"=>4.55, "v"=>1.05, "w"=>0.04, "x"=>0.14, "y"=>1.09, "z"=>0.47} )
#Language::Definition.new(:english, :letter_frequency => {"a"=>8.34, "b"=>1.54, "c"=>2.73, "d"=>4.14, "e"=>12.6, "f"=>2.03, "g"=>1.92, "h"=>6.11, "i"=>6.71, "j"=>0.23, "k"=>0.87, "l"=>4.24, "m"=>2.53, "n"=>6.8, "o"=>7.7, "p"=>1.66, "q"=>0.09, "r"=>5.68, "s"=>6.11, "t"=>9.37, "u"=>2.85, "v"=>1.06, "w"=>2.34, "x"=>0.2, "y"=>2.04, "z"=>0.06} )
#Language::Definition.new(:french, :letter_frequency => {"a"=>8.13, "b"=>0.93, "c"=>3.15, "d"=>3.55, "e"=>15.1, "f"=>0.96, "g"=>0.97, "h"=>1.08, "i"=>6.94, "j"=>0.71, "k"=>0.16, "l"=>5.68, "m"=>3.23, "n"=>6.42, "o"=>5.27, "p"=>3.03, "q"=>0.89, "r"=>6.43, "s"=>7.91, "t"=>7.11, "u"=>6.05, "v"=>1.83, "w"=>0.04, "x"=>0.42, "y"=>0.19, "z"=>0.21} )
#Language::Definition.new(:german, :letter_frequency => {"a"=>5.58, "b"=>1.96, "c"=>3.16, "d"=>4.98, "e"=>16.93, "f"=>1.49, "g"=>3.02, "h"=>4.98, "i"=>8.02, "j"=>0.24, "k"=>1.32, "l"=>3.6, "m"=>2.55, "n"=>10.53, "o"=>2.24, "p"=>0.67, "q"=>0.02, "r"=>6.89, "s"=>6.42, "t"=>5.79, "u"=>3.83, "v"=>0.84, "w"=>1.78, "x"=>0.05, "y"=>0.05, "z"=>1.21} )


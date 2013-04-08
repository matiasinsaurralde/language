#!/usr/bin/env ruby
# encoding: utf-8

require 'oj'
require 'pp'

module Language
	module NGram

		def self.abecedary_frequency(d, percentages = true)

			unigrams, _unigrams, total = {}, {}, 0

			abc = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z' ]

			abc.each do |l|
				unigrams.store( l, 0 )
			end

			splits = d.downcase.split(//)

			splits.each do |q|
				if abc.include?(q)
					unigrams[q] += 1
				end
				total += 1
			end

			#unigrams.each {|k,v| _unigrams.store(k,  ( v.to_f / total.to_f * 100.0 ).round(2)  ) }
			unigrams.each {|k,v| _unigrams.store(k,  (percentages == true ? ( v.to_f / total.to_f * 100.0 ).round(2) : v )  ) }

			return _unigrams

		end

		def self.frequency(nn, d, percentages = true)
			results = {}
			splits = d.downcase.split(//)
			nn += 1; nn.times.to_a[1, nn].each do |n|
				results.store(n, {})
				total = 0
				# splits = d.downcase.split(//)
				i = 0; splits.each do |q|

					if n > 1
						n.times.to_a[1,n].each do |p|
							q += "#{splits[i+p]}"
						end
					end

					case n
						when 2
							#q = "#{q}#{splits[i+1]}"
						when 3
							#q = "#{q}#{splits[i+1]}#{splits[i+2]}"
						when 4
							#q = "#{q}#{splits[i+1]}#{splits[i+2]}#{splits[i+3]}"
					end

					if results[n][q]
						results[n][q] += 1
					else
						results[n].store(q, 1)
					end

					i += 1
					total += 1
				end

				[' ', '?', '!', '.', ',', ';', ':', "\r", "\n", "-", "+", "_"].each do |noise|
					results[n].each do |k,v|
						if k.include?(noise)
							results[n].delete(k)
						end
					end
				end

				_o = results[n].sort_by {|k,v| v}.reverse
				results[n] = {}
				_o.each do |a|
					if percentages
						percentage = (  a[1].to_f / total.to_f * 100.0 ).round(2)
						if percentage > 0.1
							results[n].store(a[0], percentage )
						end
					else
						results[n].store(a[0], a[1])
					end
				end

			end

			if !percentages; results.store( :character_count, splits.size ); end

			return results
		end

		def self.ngrams_please( input_file, depth, output_dir )

			if !Dir.exists?(output_dir)
				Dir.mkdir(output_dir)
			end

			raw_json = File.read( input_file ).force_encoding('iso-8859-1').encode('utf-8').downcase

			texts, results = Oj.load( raw_json ), {}

			puts "loading #{input_file} ( #{texts.size} texts), depth: #{depth.to_s}"

			results = { :character_count => 0, :ngrams => {} }

			c = 0; texts.values.each do |s|

				just_text = s.join(' ')

				puts " --- #{c}/#{texts.size}"

				if depth == :abc

					results[ :character_count] += just_text.size

					results[ :ngrams ].store( c, NGram::abecedary_frequency( just_text, false ) )

					# pp results

				else

					output = NGram::frequency( depth, just_text, false )

					results[ :character_count ] += output[ :character_count ]

					results[ :ngrams ].store( c, output )

					# pp results

				end


				if depth == :abc
					open(File.join(output_dir, 'abc.json'), 'w') do |f|; f.print( Oj.dump(results) ); end
				else
					open(File.join(output_dir, 'bigrams_trigrams.json'), 'w') do |f|; f.print( Oj.dump(results) ); end
				end

				c += 1
			end

		end
	end
end

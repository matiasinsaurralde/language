#!/usr/bin/env ruby
# encoding: utf-8

require 'pp'

module Language
	module NGram
		def self.frequency(nn, d)
			results = {}
			nn += 1; nn.times.to_a[1, nn].each do |n|
				results.store(n, {})
				total = 0
				splits = d.downcase.split(//)
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
					percentage =(  a[1].to_f / total.to_f * 100.0 ).round(2)
					if percentage > 0.1
						results[n].store(a[0], percentage )
					end
				end

			end
			return results
		end
	end
end

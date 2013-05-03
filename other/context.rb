# encoding: utf-8

require 'pp'

class Text

	def initialize(s)

		@terms, @body = {}, s.downcase.gsub("\n", "")

		extract_terms()

	end

	def extract_terms()

		_terms = {}

		splits = @body.split(' ')

		splits.each do |t|
			t.gsub!(/(,|\.)/, '')
			if !_terms[t]
				_terms.store(t, 0)
			end
			_terms[t] += 1
		end

		_terms.each do |term, count|
			_terms[term] = ( count.to_f / splits.size.to_f * 100.0 ).round(1)
		end

		_terms.sort_by {|term, weight| weight }.reverse.each do |term, weight|
			@terms.store( term, weight )
		end

	end

	def terms
		return @terms
	end

end


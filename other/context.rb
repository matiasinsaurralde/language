# encoding: utf-8

require 'pp'

class Hash; def percentages!(total, round = 1); self.each {|k,v| self[k] = (v.to_f / total.to_f * 100.0).round( round ) }; end; def most_frequent; return self.sort_by {|k,v| v }.reverse.to_h; end; def less_frequent; return self.sort_by{|k,v| v}.to_h; end; end

class Array; def to_h; _ = {}; self.each do |n|; _.store( n[0], n[1] ); end; return _; end; end

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

		@terms = _terms.percentages!( splits.size ).most_frequent()

		#puts "--"
		#pp @terms.to_a[0, 20]

	end

	def terms()
		@terms
	end

end

class Context
	def initialize()
		@texts = []
		# @global_terms = {}
	end

	def <<(text)

		@texts << text

	end

	def update_frequency()
		@global_terms = {}

		@texts.each do |text|
			puts text.object_id
			text.terms.each do |term, weight|
				if !@global_terms[term]
					@global_terms.store( term, 0 )
				end
				@global_terms[term] += 1
			end
		end

		@global_terms.each do |term, presence|
			if presence == @texts.size
				@global_terms.percentages!( @texts.size )
			end
		end
	end

	def global_frequency()
		return @global_terms.less_frequent()
	end

	def texts()
		@texts
	end
end

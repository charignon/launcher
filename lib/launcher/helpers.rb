require "text"

module Helper
	def self.similar(list, name, treshold=2)
		match = list.inject([]) do |ary, val|
			ary << val if Text::Levenshtein.distance(name, val) < treshold
			ary
		end
	end

	def self.highlight_display list
		puts list.map(&:highlight_first).join("\n")
	end
end

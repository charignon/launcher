
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


module MacFinder
	# Mac related data
	APP_PATTERN = /([^\.]+)\.app/
	BASE_FOLDER = "/Applications"
	EXTENSION_FOLDER = "Contents/MacOS"
	EXTENSION = ".app"

	def list
		@list ||= `ls #{BASE_FOLDER}/`.gsub(APP_PATTERN,'\1').split("\n")
	end

	def exec_cmd dict
		name = dict.fetch(:name)
		args = dict.fetch(:args,'')
		"#{BASE_FOLDER}/#{name}#{EXTENSION}/#{EXTENSION_FOLDER}/#{name} #{args}"
	end
end



class NotFoundException < Exception

end

class Application < Struct.new(:name, :args, :found)
	class << self
		include MacFinder
	end

	def closest_names
		return [name] if Application.list.include?(name)
		Helper::similar(Application.list, name)
	end

	def not_found?
		!found
	end

	def exec
		raise NotFoundException if not_found?
		args_dict = 
		{
			:name => name,
			:args => args
		}
		`#{Application.exec_cmd(args_dict)}` unless fork
	end

	#formatted name to escape the spaces
	def f_name
		name.gsub(" ","\\\ ")	
	end

	def self.find ary
		app = Application.new(ARGV.join(" "), "", false)
		app.found = true if Application.list.include?(app.name)
		app
	end

end

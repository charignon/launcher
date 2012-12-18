
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

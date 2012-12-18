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
#--
#          DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                  Version 2, December 2004
#
#          DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
# TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION 
#
# 0. You just DO WHAT THE FUCK YOU WANT TO.
#++

module FFI; module Inline

Compiler.define Compiler[:gcc], :gxx, 'g++' do
	def exists?
		`g++ -v 2>&1'`; $?.success?
	end

	def input
		File.join(Inline.directory, "#{digest}.cpp").tap {|path|
			File.open(path, 'w') { |f| f.write(@code) } unless File.exist?(path)
		}
	end

	def ldshared
		if RbConfig::CONFIG['target_os'] =~ /darwin/
			"g++ -dynamic -bundle -fPIC #{options} #{ENV['LDFLAGS']}"
		else
			"g++ -shared -fPIC #{options} #{ENV['LDFLAGS']}"
		end
	end
end

end; end

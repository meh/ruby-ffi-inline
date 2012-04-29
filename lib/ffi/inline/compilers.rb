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

class Compiler
	Extension = case RbConfig::CONFIG['target_os']
		when /darwin/      then 'dylib'
		when /mswin|mingw/ then 'dll'
		else                    'so'
		end

	@compilers = []

	def self.[] (name)
		return name if name.is_a?(Compiler)

		@compilers.find {|compiler|
			compiler.name.downcase == name.downcase ||
			compiler.aliases.any? { |ali| ali.downcase == name.downcase }
		}
	end

	def self.define (name, *aliases, &block)
		inherit_from = self

		if name.is_a?(Compiler)
			name = name.class
		end

		if name.is_a?(Class)
			inherit_from = name
			name         = aliases.shift
		end

		@compilers << Class.new(inherit_from, &block).new(name, *aliases)
	end

	attr_reader   :name, :aliases
	attr_accessor :options

	def initialize (name, *aliases)
		@name    = name
		@aliases = aliases
	end

	def exists?
		raise 'the Compiler has not been specialized'
	end

	def compile
		raise 'the Compiler has not been specialized'
	end
end

end; end

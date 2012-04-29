#--
#          DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                  Version 2, December 2004
#
#          DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
# TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION 
#
# 0. You just DO WHAT THE FUCK YOU WANT TO.
#++

require 'ffi/inline/builders/c'
require 'ffi/inline/compilers/gxx'

module FFI; module Inline

Builder.define Builder[:c], :cplusplus, :cxx, :cpp, 'c++' do
	def initialize (code = '', options = {})
		super(code, options) rescue nil

		use_compiler options[:use_compiler] || options[:compiler] || :gxx
	end

	def function (code, signature = nil)
		parsed = parse_signature(code)

		if signature
			parsed[:arguments] = signature[:arguments] if signature[:arguments]
			parsed[:return]    = signature[:return]    if signature[:return]
			parsed[:blocking]  = signature[:blocking]  if signature[:blocking]
		end

		@signatures << parsed

		raw %{extern "C" {#{code} }\n}
	end
end

end; end

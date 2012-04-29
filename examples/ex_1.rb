$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), '../lib')))
require 'ffi/inline'

class Foo
  extend FFI::Inline

  inline 'void say_hello (char* name) { printf("Hello, %s\n", name); }'
end

Foo.new.say_hello('foos')

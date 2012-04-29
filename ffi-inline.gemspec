Kernel.load 'lib/ffi/inline/version.rb'

Gem::Specification.new {|s|
  s.name         = 'ffi-inline'
  s.version      = FFI::Inline::VERSION
  s.authors      = 'meh.'
  s.email        = 'meh@paranoici.org'
  s.homepage     = 'http://github.com/meh/ruby-ffi-inline'
  s.platform     = Gem::Platform::RUBY
  s.summary      = 'Inline C/C++ in Ruby easily and cleanly.'

  s.files         = `git ls-files`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ['lib']

  s.add_dependency 'ffi', '>=0.4.0'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
}

# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'test_bench'
  s.version = '0.9.0.rc4'

  s.authors = ['Nathan Ladd']
  s.homepage = 'https://github.com/ntl/test-bench'
  s.email = 'nathanladd+github@gmail.com'
  s.licenses = %w(MIT)
  s.summary = "Frugal ruby test framework"
  s.description = "Test framework designed for code that can be tested effectively without an elaborate test framework."

  s.executables = ['bench']
  s.bindir = 'bin'

  s.require_paths = %w(lib)
  s.files = Dir.glob 'lib/**/*'
  s.platform = Gem::Platform::RUBY
end

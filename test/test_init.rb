require_relative '../init'

require 'ostruct'

#if ENV.key?('SELF_TEST') && TestBench::Settings::Data::Environment::Parsers::Boolean.(ENV['SELF_TEST'])
  #require 'test_bench/activate'
#else
  require 'test_bench/bootstrap'; TestBench::Bootstrap.activate
#end

require_relative './fixtures/fixtures_init'

require 'test_bench/controls'

Controls = TestBench::Controls

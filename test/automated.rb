require_relative './test_init'

require 'test_bench/bootstrap'
TestBench::Bootstrap.activate

paths = ARGV.dup
paths << File.join(__dir__, 'automated') if paths.empty?

TestBench::Bootstrap::Run.(*paths) or exit 1

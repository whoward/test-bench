ENV['TEST_BENCH_INTERNAL_LOG_LEVEL'] ||= 'trace'

require_relative '../init'

require 'test_bench/controls'

Controls = TestBench::Controls

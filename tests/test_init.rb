ENV['TEST_BENCH_RECORD_TELEMETRY'] ||= 'on'

require 'tempfile'

require_relative '../init'

require 'test_bench/controls'

Controls = TestBench::Controls

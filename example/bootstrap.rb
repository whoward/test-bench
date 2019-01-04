#!/usr/bin/env ruby

require_relative '../init'

require 'test_bench/bootstrap'
TestBench::Bootstrap.activate

module TestBench
  Fixture = Bootstrap::Fixture

  module Telemetry
    def self.configure(_)
    end
  end
end

paths = ARGV.dup
paths << File.join(__dir__, 'test', 'automated') if paths.empty?

TestBench::Bootstrap::Run.(*paths) or exit 1

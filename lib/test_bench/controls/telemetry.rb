module TestBench
  module Controls
    module Telemetry
      def self.example file=nil, failures: nil, errors: nil
        failures ||= 1
        errors ||= 1
        file ||= Path.example

        telemetry = TestBench::Telemetry.new(
          [file],   # files
          1,        # passes
          failures, # failures
          1,        # skips
          11,       # assertions
          errors,   # errors
          t0,       # start_time
          t1,       # stop_time
        )
        telemetry.failed = true unless failures.zero? and errors.zero?
        telemetry
      end

      def self.t0
        Clock::Elapsed.t0
      end

      def self.t1
        Clock::Elapsed.t1
      end

      def self.elapsed_time
        "1m1.111s"
      end

      module Summary
        def self.example telemetry=nil
          telemetry ||= Telemetry.example

          tests_per_second = Rational telemetry.tests, telemetry.elapsed_time

          error_label = if telemetry.errors == 1 then 'error' else 'errors' end

          "Ran %d tests in 1m1.111s (%.3fs tests/second)\n1 passed, 1 skipped, %d failed, 0 total errors" %
            [telemetry.tests, tests_per_second, telemetry.failures]
        end
      end

      module Error
        def self.example
          Telemetry.example file, :errors => 1, :failures => 0
        end

        def self.file
          'error.rb'
        end
      end

      module Failed
        def self.example
          Telemetry.example file, :errors => 0, :failures => 1
        end

        def self.file
          'fail.rb'
        end
      end

      module Passed
        def self.example
          Telemetry.example file, :errors => 0, :failures => 0
        end

        def self.file
          'pass.rb'
        end
      end
    end
  end
end

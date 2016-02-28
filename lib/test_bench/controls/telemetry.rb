module TestBench
  module Controls
    module Telemetry
      def self.example file=nil, failures: nil, errors: nil
        failures ||= 1
        errors ||= 1
        file ||= Path.example

        TestBench::Telemetry.new(
          [file],   # files
          1,        # passes
          failures, # failures
          1,        # skips
          11,       # assertions
          errors,   # errors
          t0,       # start_time
          t1,       # stop_time
        )
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

          "Ran %d tests in 1m1.111s (%.3fs tests/second); 1 passed, 1 skipped, %d failed" %
            [telemetry.tests, tests_per_second, telemetry.failures]
        end
      end

      module Merged
        def self.example
          files = [Passed.file, Failed.file, Error.file]

          t0 = Telemetry.t0
          t1 = Telemetry.t1

          TestBench::Telemetry.new(
            files,
            3,   # passes
            1,   # failures
            3,   # skips
            33,  # assertions
            1,   # errors
            t0,  # start_time
            t1,  # stop_time
          )
        end

        def self.first
          Passed.example
        end

        def self.second
          Failed.example
        end

        def self.third
          Error.example
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

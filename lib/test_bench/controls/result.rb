module TestBench
  module Controls
    module Result
      def self.example file=nil, failures: nil, errors: nil
        failures ||= 1
        errors ||= 1
        file ||= Path.example

        TestBench::Result.new(
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
        def self.example result=nil
          result ||= Result.example

          tests_per_second = Rational result.tests, result.elapsed_time

          error_label = if result.errors == 1 then 'error' else 'errors' end

          "Ran %d tests in 1m1.111s (%.3fs tests/second)\n1 passed, 1 skipped, %d failed, 0 total errors" % [result.tests, tests_per_second, result.failures]
        end
      end

      module Merged
        def self.example
          files = [Passed.file, Failed.file, Error.file]

          t0 = Result.t0
          t1 = Result.t1

          TestBench::Result.new(
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
          Result.example file, :errors => 1, :failures => 0
        end

        def self.file
          'error.rb'
        end
      end

      module Failed
        def self.example
          Result.example file, :errors => 0, :failures => 1
        end

        def self.file
          'fail.rb'
        end
      end

      module Passed
        def self.example
          Result.example file, :errors => 0, :failures => 0
        end

        def self.file
          'pass.rb'
        end
      end
    end
  end
end

module TestBench
  module Controls
    module Telemetry
      def self.example file=nil, failures: nil
        failures ||= 1
        file ||= Path.example

        TestBench::Telemetry.new(
          [file],   # files
          1,        # passes
          failures, # failures
          1,        # skips
          11,       # assertions
          t0,       # start_time
          t1,       # stop_time
        )
      end

      def self.data file=nil
        file ||= Path.example

        JSON.generate(
          :files => [file],
          :passes => 1,
          :failures => 1,
          :skips => 1,
          :assertions => 11,
          :start_time => t0.iso8601(5),
          :stop_time => t1.iso8601(5),
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

      module Merged
        def self.example
          files = [Passed.file, Failed.file]

          t0 = Telemetry.t0
          t1 = Telemetry.t1

          TestBench::Telemetry.new(
            files,
            2,   # passes
            1,   # failures
            2,   # skips
            22,  # assertions
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
      end

      module Failed
        def self.example
          Telemetry.example file, :failures => 1
        end

        def self.file
          'fail.rb'
        end
      end

      module Passed
        def self.example
          Telemetry.example file, :failures => 0
        end

        def self.file
          'pass.rb'
        end
      end
    end
  end
end

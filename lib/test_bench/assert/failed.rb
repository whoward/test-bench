module TestBench
  class Assert
    class Failed < StandardError
      attr_reader :backtrace_locations

      def initialize backtrace_locations
        @backtrace_locations = backtrace_locations
      end

      def self.build backtrace_locations=nil
        backtrace_locations ||= caller_locations
        new backtrace_locations
      end

      def backtrace
        backtrace_locations.map &:to_s
      end

      def frame
        backtrace_locations[0]
      end

      def to_s
        "Assertion failed"
      end
    end
  end
end

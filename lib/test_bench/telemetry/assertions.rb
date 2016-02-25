module TestBench
  class Telemetry
    module Assertions
      def elapsed? seconds
        seconds == elapsed_time
      end

      def executed? *files
        files.all? do |file|
          self.files.include? file
        end
      end
    end
  end
end

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

      def record_count control_event
        sink.count do |event| event == control_event end
      end

      def recorded_any? control_event
        count = record_count control_event
        count > 0
      end

      def recorded_error?
        recorded_any? :error_raised
      end
    end
  end
end

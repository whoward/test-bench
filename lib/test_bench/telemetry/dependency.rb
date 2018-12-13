module TestBench
  class Telemetry
    module Dependency
      attr_writer :telemetry
      def telemetry
        @telemetry ||= Telemetry.new
      end
    end
  end
end

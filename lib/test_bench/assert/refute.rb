module TestBench
  module Assert
    module Refute
      extend self

      def refute(subject=ArgumentOmitted, telemetry: nil, caller_location: nil, &block)
        telemetry ||= TestBench::Telemetry.instance
        caller_location ||= caller_locations[0]

        Evaluate.(subject, negate: true, telemetry: telemetry, caller_location: caller_location, &block)
      end

      class << self
        alias_method :call, :refute
      end
    end
  end
end

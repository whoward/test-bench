module TestBench
  module Assert
    ArgumentOmitted = Object.new

    extend self

    def assert(subject=ArgumentOmitted, telemetry: nil, caller_location: nil, &block)
      telemetry ||= TestBench::Telemetry.instance
      caller_location ||= caller_locations[0]

      Evaluate.(subject, negate: false, telemetry: telemetry, caller_location: caller_location, &block)
    end

    class << self
      alias_method :call, :assert
    end
  end
end

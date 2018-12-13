module TestBench
  module Comment
    extend self

    def comment(prose, telemetry: nil, caller_location: nil)
      telemetry ||= TestBench::Telemetry.instance
      caller_location ||= caller_locations[0]

      commented = Telemetry::Commented.new(prose, caller_location)

      telemetry.record(commented)
    end

    class << self
      alias_method :call, :comment
    end

    module Telemetry
      Commented = TestBench::Telemetry::Record.define(:prose, caller_location: true)
    end
  end
end

module TestBench
  module Assert
    module Telemetry
      Asserted = TestBench::Telemetry::Record.define(:subject, caller_location: true)
      AssertionPassed = TestBench::Telemetry::Record.define(:subject, caller_location: true)
      AssertionFailed = TestBench::Telemetry::Record.define(:subject, :failure, caller_location: true)
    end
  end
end

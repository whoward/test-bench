module TestBench
  module Test
    extend self

    def test(prose=nil, abort_on_error: nil, telemetry: nil, caller_location: nil, &block)
      if abort_on_error.nil?
        abort_on_error = Settings.get(:abort_on_error)
      end

      telemetry ||= TestBench::Telemetry.instance
      caller_location ||= caller_locations[0]

      if block.nil?
        telemetry.record(Telemetry::TestSkipped.new(prose, caller_location))
        return false
      end

      telemetry.record(Telemetry::TestStarted.new(prose, caller_location))

      begin
        block.()

        telemetry.record(Telemetry::TestPassed.new(prose, caller_location))

        return true

      rescue => error
        telemetry.record(Telemetry::ErrorRaised.new(error, caller_location))

        telemetry.record(Telemetry::TestFailed.new(prose, caller_location))

        if abort_on_error
          exit 1
        end

        return false

      ensure
        telemetry.record(Telemetry::TestFinished.new(prose, caller_location))
      end
    end

    class << self
      alias_method :call, :test
    end

    module Telemetry
      TestPassed = TestBench::Telemetry::Record.define(:prose, caller_location: true)
      TestFailed = TestBench::Telemetry::Record.define(:prose, caller_location: true)
      TestSkipped = TestBench::Telemetry::Record.define(:prose, caller_location: true)
      TestStarted = TestBench::Telemetry::Record.define(:prose, caller_location: true)
      TestFinished = TestBench::Telemetry::Record.define(:prose, caller_location: true)

      ErrorRaised = TestBench::Telemetry::Record.define(:error, caller_location: true)
    end
  end
end

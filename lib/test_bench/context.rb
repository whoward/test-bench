module TestBench
  module Context
    extend self

    def context(prose=nil, telemetry: nil, abort_on_error: nil, caller_location: nil, &block)
      if abort_on_error.nil?
        abort_on_error = Settings.get(:abort_on_error)
      end

      telemetry ||= TestBench::Telemetry.instance
      caller_location ||= caller_locations[0]

      telemetry.record(Telemetry::ContextEntered.new(prose, caller_location))

      begin
        block.()

        return true

      rescue => error
        telemetry.record(Telemetry::ErrorRaised.new(error, caller_location))

        if abort_on_error
          exit 1
        end

        return false

      ensure
        telemetry.record(Telemetry::ContextExited.new(prose, caller_location))
      end
    end

    class << self
      alias_method :call, :context
    end

    module Telemetry
      ContextEntered = TestBench::Telemetry::Record.define(:prose, caller_location: true)
      ContextExited = TestBench::Telemetry::Record.define(:prose, caller_location: true)

      ErrorRaised = Test::Telemetry::ErrorRaised
    end
  end
end

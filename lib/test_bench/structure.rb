module TestBench
  module Structure
    def assert subject=nil, mod=nil, &block
      telemetry = Telemetry::Registry.get binding

      unless Assert.(subject, mod, &block)
        raise Assert::Failed.build caller_locations[0]
      end

    ensure
      telemetry.asserted
    end

    def context prose=nil, &block
      telemetry = Telemetry::Registry.get binding
      settings = Settings::Registry.get binding

      begin
        telemetry.context_entered prose
        block.()

      rescue => error
        Structure.error error, binding

      ensure
        telemetry.context_exited prose
      end
    end

    def test prose=nil, &block
      telemetry = Telemetry::Registry.get binding

      prose ||= 'Test'

      if block.nil?
        telemetry.test_skipped prose
        return
      end

      begin
        telemetry.test_started prose
        block.()
        telemetry.test_passed prose

      rescue => error
        telemetry.test_failed prose
        Structure.error error, binding

      ensure
        telemetry.test_finished prose
      end
    end

    def self.error error, binding
      telemetry = Telemetry::Registry.get binding
      settings = Settings::Registry.get binding

      telemetry.error_raised error

      exit 1 if settings.fail_fast
    end
  end
end

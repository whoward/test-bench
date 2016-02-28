module TestBench
  module Structure
    def assert subject=nil, mod=nil, &block
      telemetry = Telemetry::Registry.get binding

      unless Assert.(subject, mod, &block)
        raise Assert::Failed.new caller_locations
      end

    ensure
      telemetry.asserted
    end

    def context prose=nil, &block
      telemetry = Telemetry::Registry.get binding
      settings = Settings::Registry.get binding

      begin
        block.()
      rescue => error
        telemetry.error_raised error

        exit 1 if settings.fail_fast
      end
    end

    def test prose=nil, &block
      telemetry = Telemetry::Registry.get binding

      prose ||= 'Test'

      context prose do
        begin
          block.()
          telemetry.test_passed prose
        rescue => error
          telemetry.test_failed prose
          raise error
        end
      end
    end
  end
end

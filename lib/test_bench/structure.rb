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

      begin
        block.()
      rescue => error
        telemetry.error_raised
      end
    end

    def test prose=nil, &block
      telemetry = Telemetry::Registry.get binding

      prose ||= 'Test'

      context prose do
        begin
          block.()
        rescue => error
          telemetry.test_failed
        end
      end
    end
  end
end

module TestBench
  module Structure
    def assert subject=nil, mod=nil, &block
      unless Assert.(subject, mod, &block)
        raise Assert::Failed.new caller_locations
      end

    ensure
      telemetry = Telemetry::Registry.get binding
      telemetry.asserted
    end

    def context prose=nil, &block
      telemetry = Telemetry::Registry.get binding

      begin
        block.()
      rescue => error
        telemetry.test_failed
      end
    end
  end
end

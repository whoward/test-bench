module TestBench
  module Controls
    module Output
      def self.attach binding, level=nil
        level ||= :verbose

        output = TestBench::Output.new level

        subscription = TestBench::Telemetry::Subscription.new output

        telemetry = TestBench::Telemetry::Registry.get binding
        telemetry.add_observer subscription

        output
      end
    end
  end
end

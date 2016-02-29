module TestBench
  module Controls
    module Output
      def self.attach binding, level=nil
        level ||= :verbose

        output = TestBench::Output.new level

        telemetry = TestBench::Telemetry::Registry.get binding
        telemetry.add_observer output

        output
      end
    end
  end
end

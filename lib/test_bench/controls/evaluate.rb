module TestBench
  module Controls
    module Evaluate
      def self.call(&block)
        context = Context.new

        context.instance_exec(context, &block)

        context.telemetry_sink
      end

      class Context
        AssertArgumentOmitted = TestBench::Assert::ArgumentOmitted

        def telemetry
          @telemetry ||= TestBench::Telemetry.new.tap do |telemetry|
            telemetry.register_subscriber(telemetry_sink)
          end
        end

        def telemetry_sink
          @telemetry_sink ||= TestBench::Telemetry::Sink.new
        end

        def assert(subject=AssertArgumentOmitted, telemetry: nil, caller_location: nil, &block)
          telemetry ||= self.telemetry
          caller_location ||= caller_locations[0]

          TestBench::Assert.(subject, telemetry: telemetry, caller_location: caller_location, &block)
        end

        def refute(subject=AssertArgumentOmitted, telemetry: nil, caller_location: nil, &block)
          telemetry ||= self.telemetry
          caller_location ||= caller_locations[0]

          TestBench::Refute.(subject, telemetry: telemetry, caller_location: caller_location, &block)
        end

        def comment(prose, telemetry: nil, caller_location: nil)
          telemetry ||= self.telemetry
          caller_location ||= caller_locations[0]

          TestBench::Comment.(prose, telemetry: telemetry, caller_location: caller_location)
        end
      end
    end
  end
end

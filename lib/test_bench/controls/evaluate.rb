module TestBench
  module Controls
    module Evaluate
      def self.call(&block)
        context = Context.new

        context.instance_exec(context, &block)

        context.telemetry_sink
      end

      class Context
        def telemetry
          @telemetry ||= TestBench::Telemetry.new.tap do |telemetry|
            telemetry.register_subscriber(telemetry_sink)
          end
        end

        def telemetry_sink
          @telemetry_sink ||= TestBench::Telemetry::Sink.new
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

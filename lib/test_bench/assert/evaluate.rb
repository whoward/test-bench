module TestBench
  module Assert
    module Evaluate
      def self.call(subject=ArgumentOmitted, telemetry:, caller_location:, negate: nil, &block)
        negate = false if negate.nil?

        if block.nil?
          if subject == ArgumentOmitted
            raise ArgumentError, "Must supply positional or block argument (or both)"
          end

          value = subject
        else
          if subject == ArgumentOmitted
            subject = nil
          end

          value = block.(subject)
        end

        passed = value ? true : false

        if negate
          passed = !passed
        end

        telemetry.record(Telemetry::Asserted.new(subject, caller_location))

        if passed
          telemetry.record(Telemetry::AssertionPassed.new(subject, caller_location))
        else
          begin
            raise Failure, Failure.message

          rescue => failure
            backtrace = failure.backtrace.drop_while do |entry|
              !entry.start_with?(caller_location.to_s)
            end

            failure.set_backtrace(backtrace)

            telemetry.record(Telemetry::AssertionFailed.new(subject, failure, caller_location))

            raise failure
          end
        end

        passed
      end
    end
  end
end

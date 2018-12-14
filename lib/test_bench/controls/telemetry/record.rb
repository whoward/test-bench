module TestBench
  module Controls
    module Telemetry
      module Record
        def self.example(value=nil, other_value=nil, time: nil)
          value ||= 'some-value'
          other_value ||= 'other-value'

          if time == :none
            time = nil
          else
            time ||= Time.example
          end

          record = SomeSignal.new(value, other_value)
          record.time = time unless time.nil?
          record
        end

        def self.alternate(value=nil)
          value ||= 'some-value'

          OtherSignal.new(value)
        end

        def self.signal
          Signal.example
        end

        SomeSignal = TestBench::Telemetry::Record.define(:some_attribute, :other_attribute)
        OtherSignal = TestBench::Telemetry::Record.define(:some_attribute)

        Example = SomeSignal

        module Asserted
          def self.example(subject: nil, caller_location: nil, time: nil)
            subject ||= Assert::Subject.example
            caller_location ||= CallerLocation.example

            if time == :none
              time = nil
            else
              time ||= Time.example
            end

            asserted = TestBench::Assert::Telemetry::Asserted.new(subject, caller_location)
            asserted.time = time unless time.nil?
            asserted
          end

          def self.signal
            :asserted
          end
        end

        module AssertionPassed
          def self.example(subject: nil, caller_location: nil, time: nil)
            subject ||= Assert::Subject.example
            caller_location ||= CallerLocation.example

            if time == :none
              time = nil
            else
              time ||= Time.example
            end

            assertion_passed = TestBench::Assert::Telemetry::AssertionPassed.new(subject, caller_location)
            assertion_passed.time = time unless time.nil?
            assertion_passed
          end

          def self.signal
            :assertion_passed
          end
        end

        module AssertionFailed
          def self.example(subject: nil, caller_location: nil, time: nil)
            subject ||= Assert::Subject.example
            caller_location ||= CallerLocation.example

            if time == :none
              time = nil
            else
              time ||= Time.example
            end

            assertion_failed = TestBench::Assert::Telemetry::AssertionFailed.new(subject, caller_location)
            assertion_failed.time = time unless time.nil?
            assertion_failed
          end

          def self.signal
            :assertion_failed
          end
        end

        module Commented
          def self.example(prose: nil, caller_location: nil, time: nil)
            prose ||= Comment::Prose.example
            caller_location ||= CallerLocation.example

            if time == :none
              time = nil
            else
              time ||= Time.example
            end

            commented = TestBench::Comment::Telemetry::Commented.new(prose, caller_location)
            commented.time = time unless time.nil?
            commented
          end

          def self.signal
            :commented
          end
        end

        module ContextEntered
          def self.example(prose: nil, caller_location: nil)
            if prose == :none
              prose = nil
            else
              prose ||= Context::Prose.example
            end

            caller_location ||= CallerLocation.example

            TestBench::Context::Telemetry::ContextEntered.new(caller_location, prose)
          end

          def self.signal
            :context_entered
          end
        end

        module ContextExited
          def self.example(prose: nil, caller_location: nil)
            if prose == :none
              prose = nil
            else
              prose ||= Context::Prose.example
            end

            caller_location ||= CallerLocation.example

            TestBench::Context::Telemetry::ContextExited.new(caller_location, prose)
          end

          def self.signal
            :context_exited
          end
        end

        module ErrorRaised
          def self.example(error: nil, caller_location: nil, time: nil)
            error ||= Error.example
            caller_location ||= CallerLocation.example

            if time == :none
              time = nil
            else
              time ||= Time.example
            end

            error_raised = TestBench::Test::Telemetry::ErrorRaised.new(error, caller_location)
            error_raised.time = time unless time.nil?
            error_raised
          end

          def self.signal
            :error_raised
          end
        end

        module TestPassed
          def self.example(prose: nil, caller_location: nil, time: nil)
            if prose == :none
              prose = nil
            else
              prose ||= Test::Prose.example
            end

            caller_location ||= CallerLocation.example

            if time == :none
              time = nil
            else
              time ||= Time.example
            end

            test_passed = TestBench::Test::Telemetry::TestPassed.new(prose, caller_location)
            test_passed.time = time unless time.nil?
            test_passed
          end

          def self.signal
            :test_passed
          end
        end

        module TestFailed
          def self.example(prose: nil, caller_location: nil, time: nil)
            if prose == :none
              prose = nil
            else
              prose ||= Test::Prose.example
            end

            caller_location ||= CallerLocation.example

            if time == :none
              time = nil
            else
              time ||= Time.example
            end

            test_failed = TestBench::Test::Telemetry::TestFailed.new(prose, caller_location)
            test_failed.time = time unless time.nil?
            test_failed
          end

          def self.signal
            :test_failed
          end
        end

        module TestSkipped
          def self.example(prose: nil, caller_location: nil, time: nil)
            if prose == :none
              prose = nil
            else
              prose ||= Test::Prose.example
            end

            caller_location ||= CallerLocation.example

            if time == :none
              time = nil
            else
              time ||= Time.example
            end

            test_skipped = TestBench::Test::Telemetry::TestSkipped.new(prose, caller_location)
            test_skipped.time = time unless time.nil?
            test_skipped
          end

          def self.signal
            :test_skipped
          end
        end

        module TestStarted
          def self.example(prose: nil, caller_location: nil, time: nil)
            if prose == :none
              prose = nil
            else
              prose ||= Test::Prose.example
            end

            caller_location ||= CallerLocation.example

            if time == :none
              time = nil
            else
              time ||= Time.example
            end

            test_started = TestBench::Test::Telemetry::TestStarted.new(prose, caller_location)
            test_started.time = time unless time.nil?
            test_started
          end

          def self.signal
            :test_started
          end
        end

        module TestFinished
          def self.example(prose: nil, caller_location: nil, time: nil)
            if prose == :none
              prose = nil
            else
              prose ||= Test::Prose.example
            end

            caller_location ||= CallerLocation.example

            if time == :none
              time = nil
            else
              time ||= Time.example
            end

            test_finished = TestBench::Test::Telemetry::TestFinished.new(prose, caller_location)
            test_finished.time = time unless time.nil?
            test_finished
          end

          def self.signal
            :test_finished
          end
        end
      end
    end
  end
end

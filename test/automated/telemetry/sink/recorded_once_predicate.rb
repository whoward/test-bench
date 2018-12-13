require_relative '../../../test_init'

context "Telemetry" do
  context "Sink" do
    context "Recorded Once Predicate" do
      control_record = Controls::Telemetry::Record.example

      context "Multiple Telemetry Records" do
        sink = TestBench::Telemetry::Sink.new

        duplicate_record = Controls::Telemetry::Record.alternate

        sink.record(control_record)
        sink.record(duplicate_record)
        sink.record(duplicate_record)

        context "No Argument" do
          test "Returns false" do
            refute(sink.recorded_once?)
          end
        end

        context "Signal Argument" do
          context "Matches signal that was recorded once" do
            test "Predicate returns true" do
              assert(sink.recorded_once?(control_record.signal))
            end
          end

          context "Matches signal that was recorded more than once" do
            test "Predicate returns false" do
              refute(sink.recorded_once?(duplicate_record.signal))
            end
          end

          context "Does not match signal that was recorded" do
            test "Predicate returns false" do
              refute(sink.recorded_once?(:non_recorded_signal))
            end
          end
        end

        context "Block Argument" do
          context "Returns a positive value for exactly one record" do
            test "Predicate returns true" do
              assert(sink.recorded_once? { |record|
                record.signal == control_record.signal
              })
            end
          end

          context "Returns a positive value for more than one record" do
            test "Predicate returns false" do
              refute(sink.recorded_once? { |record|
                record.signal == duplicate_record.signal
              })
            end
          end

          context "Does not return a positive value for any record" do
            test "Predicate returns false" do
              refute(sink.recorded_once? { false })
            end
          end

          test "Records are yielded to block" do
            records = []

            sink.recorded_once? do |record|
              records << record
            end

            assert(records == [control_record, duplicate_record, duplicate_record])
          end
        end
      end

      context "One Telemetry Record" do
        sink = TestBench::Telemetry::Sink.new

        sink.record(control_record)

        context "No Argument" do
          test "Predicate returns true" do
            assert(sink.recorded_once?)
          end
        end
      end

      context "Telemetry Not Recorded" do
        sink = TestBench::Telemetry::Sink.new

        test "Predicate returns false" do
          refute(sink.recorded_once?)
        end
      end
    end
  end
end

require_relative '../../../test_init'

context "Telemetry" do
  context "Sink" do
    context "Recorded Predicate" do
      context "Telemetry Recorded" do
        record = Controls::Telemetry::Record.example
        signal = record.signal

        sink = TestBench::Telemetry::Sink.new

        sink.record(record)

        context "No Argument" do
          test "Predicate returns true" do
            assert(sink.recorded?)
          end
        end

        context "Signal Argument" do
          context "Matches Signal That Was Recorded" do
            test "Predicate returns true" do
              assert(sink.recorded?(signal))
            end
          end

          context "Does Not Match Signal That Was Recorded" do
            alternate_signal = Controls::Telemetry::Signal.alternate

            test "Predicate returns false" do
              refute(sink.recorded?(alternate_signal))
            end
          end
        end

        context "Block Argument" do
          context "Returns a Positive Value" do
            test "Predicate returns true" do
              assert(sink.recorded? { true })
            end
          end

          context "Returns a Negative Value" do
            test "Predicate returns false" do
              refute(sink.recorded? { false })
            end
          end

          test "Records are yielded to block" do
            yielded_record = nil

            sink.recorded? do |rec|
              yielded_record = rec
            end

            assert(yielded_record == record)
          end
        end
      end

      context "Telemetry Not Recorded" do
        sink = TestBench::Telemetry::Sink.new

        test "Predicate returns false" do
          refute(sink.recorded?)
        end
      end
    end
  end
end

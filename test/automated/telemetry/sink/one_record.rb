require_relative '../../../test_init'

context "Telemetry" do
  context "Sink" do
    context "One Record" do
      control_record = Controls::Telemetry::Record.example

      signal = control_record.signal

      context "One Signal Recorded" do
        sink = TestBench::Telemetry::Sink.new

        sink.record(control_record)

        context "No Argument" do
          test "Returns signal that was recorded" do
            assert(sink.one_record == control_record)
          end
        end
      end

      context "Multiple Signals Recorded" do
        sink = TestBench::Telemetry::Sink.new

        sink.record(control_record)

        duplicate_record = Controls::Telemetry::Record.alternate
        sink.record(duplicate_record)
        sink.record(duplicate_record)

        context "No Argument" do
          begin
            sink.one_record
          rescue TestBench::Telemetry::Sink::Error => error
          end

          test "Raises error" do
            refute(error.nil?)
          end
        end

        context "Signal Argument" do
          context "Matches a signal that was recorded once" do
            matched_record = sink.one_record(signal)

            test "Returns record" do
              assert(matched_record == control_record)
            end
          end

          context "Matches signal that was recorded more than once" do
            begin
              sink.one_record(duplicate_record.signal)
            rescue TestBench::Telemetry::Sink::Error => error
            end

            test "Raises error" do
              refute(error.nil?)
            end
          end

          context "Does not match signal that was recorded" do
            matched_record = sink.one_record(:non_recorded_signal)

            test "Returns nil" do
              assert(matched_record.nil?)
            end
          end
        end

        context "Block Argument" do
          context "Block returns a positive value for exactly one record" do
            matched_record = sink.one_record do |record|
              record.signal == signal
            end

            test "Returns matching record" do
              assert(matched_record == control_record)
            end
          end

          context "Block returns a positive value for more than one record" do
            begin
              sink.one_record do |record|
                record.signal == duplicate_record.signal
              end
            rescue TestBench::Telemetry::Sink::Error => error
            end

            test "Raises error" do
              refute(error.nil?)
            end
          end

          context "Block does not return a positive value for any record" do
            matched_record = sink.one_record { false }

            test "Returns nil" do
              assert(matched_record.nil?)
            end
          end

          test "Records are yielded to block" do
            records = []

            begin
              sink.one_record do |record|
                records << record
              end
            rescue TestBench::Telemetry::Sink::Error
            end

            assert(records == [control_record, duplicate_record, duplicate_record])
          end
        end
      end

      context "Nothing Recorded" do
        sink = TestBench::Telemetry::Sink.new

        matched_record = sink.one_record

        test "Returns nil" do
          assert(matched_record.nil?)
        end
      end
    end
  end
end

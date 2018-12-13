require_relative '../../test_init'

context "Telemetry" do
  context "Sink Subscriber" do
    telemetry = TestBench::Telemetry.new

    sink = TestBench::Telemetry::Sink.new

    telemetry.register_subscriber(sink)

    context "Signal is Recorded" do
      record = Controls::Telemetry::Record.example

      telemetry.record(record)

      test "Sink records signal" do
        assert(sink.recorded_once?(record.signal))
      end
    end
  end
end

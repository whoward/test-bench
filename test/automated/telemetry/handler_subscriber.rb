require_relative '../../test_init'

context "Telemetry" do
  context "Handler Subscriber" do
    telemetry = TestBench::Telemetry.new

    handler = Controls::Telemetry::Handler.example

    telemetry.register_subscriber(handler)

    context "Telemetry is Recorded" do
      record = Controls::Telemetry::Record.example

      telemetry.record(record)

      test "Signal is handled" do
        assert(handler.handled?(record))
      end
    end
  end
end

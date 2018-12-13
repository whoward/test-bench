require_relative '../../test_init'

context "Telemetry" do
  context "Recording" do
    telemetry = TestBench::Telemetry.new

    subscriber = Controls::Telemetry::Subscriber.example

    telemetry.register_subscriber(subscriber)

    record = Controls::Telemetry::Record.example(time: :none)
    assert(record.time.nil?)

    telemetry.record(record)

    test "Subscriber receives telemetry" do
      assert(subscriber.received?(record.signal))
    end

    test "Time attribute is set on record" do
      assert(record.time.instance_of?(::Time))
    end
  end
end

require_relative '../../test_init'

context "Telemetry" do
  context "Multiple Subscribers" do
    telemetry = TestBench::Telemetry.new

    subscriber_1 = Controls::Telemetry::Subscriber.example
    subscriber_2 = Controls::Telemetry::Subscriber.example

    telemetry.register_subscriber(subscriber_1)
    telemetry.register_subscriber(subscriber_2)

    test "Each subscriber is registered" do
      each_registered = [subscriber_1, subscriber_2].all? do |subscriber|
        telemetry.subscriber?(subscriber)
      end

      assert(each_registered)
    end

    context "Telemetry is Recorded" do
      record = Controls::Telemetry::Record.example

      signal = record.signal

      telemetry.record(record)

      test "Each subscriber receives the given record once" do
        each_received = [subscriber_1, subscriber_2].all? do |subscriber|
          subscriber.received_once?(signal)
        end

        assert(each_received)
      end
    end
  end
end

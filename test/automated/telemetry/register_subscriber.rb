require_relative '../../test_init'

context "Telemetry" do
  context "Register Subscriber" do
    telemetry = TestBench::Telemetry.new

    subscriber = Controls::Telemetry::Subscriber.example

    telemetry.register_subscriber(subscriber)

    test "Is subscribed" do
      assert(telemetry.subscriber?(subscriber))
    end

    context "Already Subscribed" do
      begin
        telemetry.register_subscriber(subscriber)
      rescue TestBench::Telemetry::Error => error
      end

      test "Raises error" do
        refute(error.nil?)
      end
    end
  end
end

require_relative '../test_init'

context "Merging telemetry" do
  test do
    control_telemetry = Controls::Telemetry::Merged.example

    telemetry1 = Controls::Telemetry::Merged.first
    telemetry2 = Controls::Telemetry::Merged.second
    telemetry3 = Controls::Telemetry::Merged.third

    telemetry = telemetry1 + telemetry2 + telemetry3

    assert telemetry == control_telemetry
  end

  context "Timestamps" do
    t0 = Time.new 2000
    t1 = Time.new 2001
    t2 = Time.new 2002

    test do
      telemetry1 = TestBench::Telemetry.build
      telemetry1.start_time = t0
      telemetry1.stop_time = t1

      telemetry2 = TestBench::Telemetry.build
      telemetry2.start_time = t1
      telemetry2.stop_time = t2

      telemetry = telemetry1 + telemetry2

      assert telemetry.start_time == t0
      assert telemetry.stop_time == t2
    end

    test "Nil values" do
      telemetry1 = TestBench::Telemetry.build
      telemetry1.start_time = t0

      telemetry2 = TestBench::Telemetry.build
      telemetry2.stop_time = t1

      telemetry = telemetry1 + telemetry2

      assert telemetry.start_time == t0
      assert telemetry.stop_time == t1
    end
  end
end

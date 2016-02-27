require_relative '../test_init'

context "Serialization" do
  test do
    control_data = Controls::Telemetry.data
    telemetry = Controls::Telemetry.example

    data = TestBench::Telemetry.dump telemetry

    assert data == control_data
  end

  test "Deserialization" do
    data = Controls::Telemetry.data
    control_telemetry = Controls::Telemetry.example

    telemetry = TestBench::Telemetry.load data

    assert telemetry == control_telemetry
  end
end

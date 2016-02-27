require_relative '../test_init'

context "Telemetry registry" do
  test "The same binding always receives the same telemetry" do
    registry = TestBench::Telemetry::Registry.new
    binding = Controls::Binding.example

    telemetry1 = registry.get binding
    telemetry2 = registry.get binding

    assert telemetry1.object_id == telemetry2.object_id
  end

  test "Different bindings receive different telemetry" do
    registry = TestBench::Telemetry::Registry.new
    binding1 = Controls::Binding.example
    binding2 = Controls::Binding.example

    telemetry1 = registry.get binding1
    telemetry2 = registry.get binding2

    assert telemetry1.object_id != telemetry2.object_id
  end

  test "The same object in a child process receives different telemetry" do
    registry = TestBench::Telemetry::Registry.new
    binding = Controls::Binding.example

    telemetry1 = registry.get binding

    child_pid = fork do
      telemetry2 = registry.get binding
      assert telemetry1.object_id != telemetry2.object_id
    end

    _, status = Process.wait2 child_pid

    assert status.exitstatus == 0
  end
end

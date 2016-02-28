require_relative '../test_init'

context "Telemetry registry" do
  test "The same object in a child process receives different instance" do
    registry = TestBench::Telemetry::Registry.build
    binding = Controls::Binding.example

    object1 = registry.get binding

    child_pid = fork do
      object2 = registry.get binding
      assert object1.object_id != object2.object_id
    end

    _, status = Process.wait2 child_pid

    assert status.exitstatus == 0
  end
end

require_relative './test_init'

context "Registry" do
  cls = Class.new do
    def self.build
      new
    end
  end

  test "The same binding always receives the same instance" do
    registry = TestBench::Registry.new cls
    binding = Controls::Binding.example

    object1 = registry.get binding
    object2 = registry.get binding

    assert object1.object_id == object2.object_id
  end

  test "Different bindings receive different instance" do
    registry = TestBench::Registry.new cls
    binding1 = Controls::Binding.example
    binding2 = Controls::Binding.example

    object1 = registry.get binding1
    object2 = registry.get binding2

    assert object1.object_id != object2.object_id
  end

  test "The same object in a child process receives different instance" do
    registry = TestBench::Registry.new cls
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

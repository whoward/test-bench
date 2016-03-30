require_relative './test_init'

context "Registry" do
  cls = Class.new do
    def self.build
      new
    end
  end

  factory = cls.method :build

  test "The same binding always receives the same instance" do
    registry = TestBench::Registry.new factory
    binding = Controls::Binding.example

    object1 = registry.get binding
    object2 = registry.get binding

    assert object1.object_id == object2.object_id
  end

  test "Different bindings receive different instance" do
    registry = TestBench::Registry.new factory
    binding1 = Controls::Binding.example
    binding2 = Controls::Binding.example

    object1 = registry.get binding1
    object2 = registry.get binding2

    refute object1.object_id == object2.object_id
  end
end

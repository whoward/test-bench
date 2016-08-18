require_relative '../test_init'

context "Test assertions" do
  context "Assert" do
    test "Positive" do
      binding = Controls::Binding.example
      script = Controls::TestScript::Passing.example
      telemetry = TestBench::Telemetry::Registry.get binding

      binding.eval script, __FILE__, __LINE__

      assert telemetry, &:recorded_asserted?
    end

    test "Negative" do
      binding = Controls::Binding.example
      script = Controls::TestScript::Failing.example
      telemetry = TestBench::Telemetry::Registry.get binding

      begin
        binding.eval script, __FILE__, __LINE__
      rescue TestBench::Assert::Failed => error
      end

      assert error
      assert telemetry, &:recorded_asserted?
    end
  end

  context "Refute" do
    test "Positive" do
      binding = Controls::Binding.example
      telemetry = TestBench::Telemetry::Registry.get binding

      binding.eval 'refute false', __FILE__, __LINE__

      assert telemetry, &:recorded_asserted?
    end

    test "Negative" do
      binding = Controls::Binding.example
      telemetry = TestBench::Telemetry::Registry.get binding

      begin
        binding.eval 'refute true', __FILE__, __LINE__
      rescue TestBench::Assert::Failed => error
      end

      assert error
      assert telemetry, &:recorded_asserted?
    end
  end
end

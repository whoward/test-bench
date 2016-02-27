require_relative './test_init'

context "Test structure" do
  context "Assertions" do
    test "Positive" do
      binding = Controls::Binding.example
      telemetry = TestBench::Telemetry::Registry.get binding

      binding.eval 'assert true', __FILE__, __LINE__

      assert telemetry.assertions == 1
    end

    test "Negative" do
      binding = Controls::Binding.example
      telemetry = TestBench::Telemetry::Registry.get binding

      begin
        binding.eval 'assert false', __FILE__, __LINE__
      rescue TestBench::Assert::Failed => error
      end

      assert error
      assert telemetry.assertions == 1
    end
  end

  context "Context" do
    test "Errors are reported" do
      binding = Controls::Binding.example
      telemetry = TestBench::Telemetry::Registry.get binding

      binding.eval 'context do fail end', __FILE__, __LINE__

      assert telemetry.failures == 1
    end
  end
end

require_relative '../test_init'

context "Context blocks" do
  test do
    binding = Controls::Binding.example
    telemetry = TestBench::Telemetry::Registry.get binding

    binding.eval 'context do end', __FILE__, __LINE__

    assert telemetry, &:recorded_context_entered?
    assert telemetry, &:recorded_context_exited?
  end

  test "Errors are recorded" do
    binding = Controls::Binding.example
    telemetry = TestBench::Telemetry::Registry.get binding

    begin
      binding.eval 'context do fail end', __FILE__, __LINE__
    rescue SystemExit
    end

    assert telemetry, &:recorded_error_raised?
  end

  test "The system exits immediately when abort on error is set" do
    binding = Controls::Binding.example
    settings = TestBench::Settings::Registry.get binding
    settings.abort_on_error = true

    begin
      binding.eval 'context do fail end', __FILE__, __LINE__
    rescue SystemExit => error
    end

    assert error
    refute error.success?
  end

  test "No block is supplied" do
    binding = Controls::Binding.example
    telemetry = TestBench::Telemetry::Registry.get binding

    binding.eval 'context', __FILE__, __LINE__

    refute telemetry, &:recorded_error_raised?
  end

  context "The outermost context exits unsuccessfully" do
    test "System exits immediately" do
      binding = Controls::Binding.example

      begin
        binding.eval 'context do fail end', __FILE__, __LINE__
      rescue SystemExit => error
      end

      assert error
      refute error.success?
    end

    test "System does not exit immediately if exit is suppressed" do
      binding = Controls::Binding.example

      begin
        binding.eval 'context :suppress_exit => true do fail end', __FILE__, __LINE__
      rescue SystemExit => error
      end

      refute error
    end
  end

  test "Prose must be a String" do
    binding = Controls::Binding.example

    assert proc { binding.eval 'context Object.new do end', __FILE__, __LINE__ } do
      raises_error? TypeError
    end
  end
end

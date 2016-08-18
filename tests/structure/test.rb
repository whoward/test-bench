require_relative '../test_init'

context "Test blocks" do
  test "Passing" do
    binding = Controls::Binding.example
    telemetry = TestBench::Telemetry::Registry.get binding

    binding.eval 'test "Some test" do end', __FILE__, __LINE__

    assert telemetry, &:recorded_test_started?
    assert telemetry, &:recorded_test_passed?
    assert telemetry, &:recorded_test_finished?
  end

  test "Failing" do
    binding = Controls::Binding.example
    telemetry = TestBench::Telemetry::Registry.get binding

    binding.eval 'test "Some test" do assert false end', __FILE__, __LINE__

    assert telemetry, &:recorded_test_failed?
  end

  test "Skipping" do
    binding = Controls::Binding.example
    telemetry = TestBench::Telemetry::Registry.get binding

    binding.eval 'test', __FILE__, __LINE__

    assert telemetry, &:recorded_test_skipped?
  end

  test %{Prose defaults to "Test"} do
    binding = Controls::Binding.example
    output = Controls::Output.attach binding
    telemetry = TestBench::Telemetry::Registry.get binding

    binding.eval 'test do end', __FILE__, __LINE__

    assert telemetry do
      test? 'Test'
    end
  end

  test "Prose must be a String" do
    binding = Controls::Binding.example
    settings = TestBench::Settings::Registry.get binding

    assert proc { binding.eval 'test Object.new do end', __FILE__, __LINE__ } do
      raises_error? TypeError
    end
  end
end

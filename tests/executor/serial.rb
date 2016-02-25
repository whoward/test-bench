require_relative '../test_init'

context "Serial executor" do
  binding = Controls::Binding.example
  file_module = Controls::FileSubstitute.example

  context "Test script finishes execution without error" do
    test "Returns true" do
      test_script_path = Controls::FileSubstitute::TestScript::Passing.path

      executor = TestBench::Executor::Serial.new binding, file_module
      executor.add test_script_path
      result = executor.()

      assert result == true
    end

    test "Records that each file was executed" do
      telemetry = TestBench::Telemetry.build
      paths = Controls::FileSubstitute::Paths.example

      executor = TestBench::Executor::Serial.new binding, file_module
      executor.telemetry = telemetry
      paths.each do |path| executor.add path end
      executor.()

      assert telemetry do
        executed? *paths
      end
    end
  end

  context "Test script raises error" do
    test "Returns false"
    test "Displays error"
  end

  context "Recording telemetry"
end

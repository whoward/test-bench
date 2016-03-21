require_relative './test_init'

context "Executor" do
  file_module = Controls::FileSubstitute.example

  test "File execution" do
    binding = Controls::Binding.example
    files = [Controls::FileSubstitute::TestScript::Passing.file]

    executor = TestBench::Executor.new binding, file_module
    executor.(files)

    assert executor.telemetry do
      executed? *files
    end
  end

  context "Result" do
    test "All passing tests returns true" do
      binding = Controls::Binding.example
      files = [Controls::FileSubstitute::TestScript::Passing.file]

      executor = TestBench::Executor.new binding, file_module
      result = executor.(files)

      assert result == true
    end

    test "An uncaught error causes the result to be false" do
      binding = Controls::Binding.example
      files = [Controls::FileSubstitute::TestScript::Error.file]

      executor = TestBench::Executor.new binding, file_module
      result = executor.(files)

      assert result == false
    end
  end

  test "Aggregated telemetry" do
    test "Assertions" do
      binding = Controls::Binding.example
      telemetry = TestBench::Telemetry::Registry.get binding
      files = [Controls::FileSubstitute::TestScript::Passing.file] * 3

      executor = TestBench::Executor.new binding, file_module
      executor.(files)

      assert executor.telemetry.assertions == 3
    end

    test "Errors" do
      binding = Controls::Binding.example
      telemetry = TestBench::Telemetry::Registry.get binding
      files = [Controls::FileSubstitute::TestScript::Error.file]

      executor = TestBench::Executor.new binding, file_module
      executor.(files)

      assert telemetry.failed?
    end
  end

  context "Files that include an __END__ part" do
    test do
      file_module.file_map['/end.rb'] = '__END__'

      binding = Controls::Binding.example
      executor = TestBench::Executor.new binding, file_module

      result = executor.(['/end.rb'])

      assert result == true
    end
  end
end

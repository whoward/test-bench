require_relative './test_init'

context "Executor" do
  file_module = Controls::FileSubstitute.example

  test "File execution" do
    binding = Controls::Binding.example
    files = [Controls::FileSubstitute::TestScript::Passing.file]

    executor = TestBench::Executor.new binding, 1, file_module
    executor.(files)

    assert executor.telemetry do
      executed? *files
    end
  end

  context "Result" do
    test "All passing tests returns true" do
      binding = Controls::Binding.example
      files = [Controls::FileSubstitute::TestScript::Passing.file]

      executor = TestBench::Executor.new binding, 1, file_module
      result = executor.(files)

      assert result == true
    end

    test "An uncaught error causes the result to be false" do
      binding = Controls::Binding.example
      files = [Controls::FileSubstitute::TestScript::Error.file]

      executor = TestBench::Executor.new binding, 1, file_module
      result = executor.(files)

      assert result == false
    end
  end

  test "Aggregated telemetry" do
    test "Assertions" do
      binding = Controls::Binding.example
      files = [Controls::FileSubstitute::TestScript::Passing.file] * 3

      executor = TestBench::Executor.new binding, 1, file_module
      executor.(files)

      assert executor.telemetry.assertions == 3
    end

    test "Errors" do
      binding = Controls::Binding.example
      telemetry = TestBench::Telemetry::Registry.get binding
      files = [Controls::FileSubstitute::TestScript::Error.file]

      executor = TestBench::Executor.new binding, 1, file_module
      executor.(files)

      assert telemetry.errors == 1
    end
  end

  test "Parallel execution" do
    binding = Controls::Binding.example
    parallel_process_max = 0
    child_count = 4
    files = [Controls::FileSubstitute::TestScript::Passing.file] * 10

    executor = TestBench::Executor.new binding, child_count, file_module
    executor.(files) do
      parallel_process_max = [parallel_process_max, executor.process_map.size].max
    end

    assert parallel_process_max == child_count
  end

  context "Fail fast setting" do
    files = [
      Controls::FileSubstitute::TestScript::Failing.file,
      Controls::FileSubstitute::TestScript::Passing.file,
    ]

    test "Enabled" do
      binding = Controls::Binding.example

      executor = TestBench::Executor.new binding, 1, file_module
      executor.settings.fail_fast = true
      executor.(files)

      assert executor.telemetry.files == files[0...1]
    end

    test "Disabled" do
      binding = Controls::Binding.example

      executor = TestBench::Executor.new binding, 1, file_module
      executor.settings.fail_fast = false
      executor.(files)

      assert executor.telemetry.files == files
    end
  end
end

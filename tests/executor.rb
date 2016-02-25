require_relative './test_init'

context "Executor" do
  file_module = Controls::FileSubstitute.example
  binding = Controls::Binding.example

  test "File execution" do
    telemetry = TestBench::Telemetry.build
    files = [Controls::FileSubstitute::TestScript::Passing.file]

    executor = TestBench::Executor.new binding, 1, file_module
    executor.telemetry = telemetry
    executor.(files)

    assert telemetry do
      executed? *files
    end
  end

  test "Aggregated telemetry" do
    test "Assertions" do
      telemetry = TestBench::Telemetry.build
      files = [Controls::FileSubstitute::TestScript::Passing.file] * 3

      executor = TestBench::Executor.new binding, 1, file_module
      executor.telemetry = telemetry
      executor.(files)

      assert telemetry.assertions == 3
    end

    test "Error"

    test "Failure"
  end

  test "Parallel execution" do
    parallel_process_max = 0
    child_count = 4
    files = [Controls::FileSubstitute::TestScript::Passing.file] * 10

    executor = TestBench::Executor.new binding, child_count, file_module
    executor.(files) do
      parallel_process_max = [parallel_process_max, executor.process_map.size].max
    end

    assert parallel_process_max == child_count
  end
end

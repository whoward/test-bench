require_relative './test_init'

context "Executor" do
  file_module = Controls::FileSubstitute.example
  binding = Controls::Binding.example

  context "File execution" do
    test do
      executor = TestBench::Executor.new binding, 1, file_module
      executor.telemetry = TestBench::Telemetry.build
      files = [Controls::FileSubstitute::TestScript::Passing.file]

      executor.add *files
      executor.()

      assert executor.telemetry do
        executed? *files
      end
    end

    test "Error"
    test "Failure"
  end

  test "Parallel execution" do
    child_count = 4
    executor = TestBench::Executor.new binding, child_count, file_module
    files = [Controls::FileSubstitute::TestScript::Passing.file] * 10

    executor.add *files
    executor.()

    assert executor do
      parallel_process_max? 4
    end
  end
end

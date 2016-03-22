require_relative './test_init'

context "Runner" do
  test "Executes all files found in paths" do
    executor = TestBench::Controls::Executor::Substitute.new
    telemetry = TestBench::Telemetry.build

    runner = TestBench::Runner.new %w(some/path other/path.rb), telemetry
    runner.expand_path = Controls::ExpandPath.example
    runner.executor = executor

    runner.()

    assert executor do
      executed? 'some/path/1.rb', 'some/path/2.rb', 'other/path.rb'
    end
  end

  test "Records that the run started and stopped" do
    telemetry = TestBench::Telemetry.build
    runner = TestBench::Runner.new %w(some/path other/path.rb), telemetry

    runner.()

    assert telemetry, &:recorded_run_started?
    assert telemetry, &:recorded_run_finished?
  end

  context "Return value" do
    test "True if tests passed" do
      telemetry = Controls::Telemetry::Passed.example
      runner = TestBench::Runner.new [], telemetry

      return_value = runner.()

      assert return_value == true
    end

    test "False if tests failed" do
      telemetry = Controls::Telemetry::Failed.example
      runner = TestBench::Runner.new [], telemetry

      return_value = runner.()

      assert !return_value
    end
  end
end

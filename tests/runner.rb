require_relative './test_init'

context "Runner" do
  test "Expands all paths into a concrete set of files and executes them" do
    executor = TestBench::Controls::Executor::Substitute.new

    runner = TestBench::Runner.new %w(some/path other/path.rb)
    runner.expand_path = Controls::ExpandPath.example
    runner.executor = executor

    runner.()

    assert executor do
      executed? 'some/path/1.rb', 'some/path/2.rb', 'other/path.rb'
    end
  end

  test "Records that the run started and stopped" do
    telemetry = TestBench::Telemetry.build
    telemetry.clock = Controls::Clock::Elapsed.example

    runner = TestBench::Runner.new %w(some/path other/path.rb)
    runner.telemetry = telemetry

    runner.()

    assert telemetry do
      elapsed? Controls::Clock::Elapsed.seconds
    end
  end

  context "Return value" do
    test "True if tests passed" do
      runner = TestBench::Runner.new []
      runner.telemetry = Controls::Telemetry::Passed.example

      return_value = runner.()

      assert return_value
    end

    test "False if tests failed" do
      runner = TestBench::Runner.new []
      runner.telemetry = Controls::Telemetry::Failed.example

      return_value = runner.()

      assert !return_value
    end
  end
end

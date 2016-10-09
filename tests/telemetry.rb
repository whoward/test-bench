require_relative './test_init'

context "Telemetry" do
  test "Record that an assertion was made" do
    telemetry = TestBench::Telemetry.build

    telemetry.asserted

    assert telemetry, &:recorded_asserted?
  end

  test "Record that a comment was made" do
    telemetry = TestBench::Telemetry.build

    telemetry.commented nil

    assert telemetry, &:recorded_comment?
  end

  test "Record that a context was entered" do
    telemetry = TestBench::Telemetry.build

    telemetry.context_entered nil

    assert telemetry, &:recorded_context_entered?
  end

  test "Record that a context was exited" do
    telemetry = TestBench::Telemetry.build

    telemetry.context_exited nil

    assert telemetry, &:recorded_context_exited?
  end

  test "Record that an error was raised" do
    result = TestBench::Telemetry.build
    error = Controls::Error.example

    result.error_raised error

    assert result, &:recorded_error_raised?
  end

  test "Record that a file finished executing" do
    telemetry = TestBench::Telemetry.build

    telemetry.file_finished 'some/file.rb'

    assert telemetry, &:recorded_file_finished?
  end

  test "Record that a file began executing" do
    telemetry = TestBench::Telemetry.build

    telemetry.file_started 'some/file.rb'

    assert telemetry, &:recorded_file_started?
  end

  test "Record that a test run began" do
    telemetry = TestBench::Telemetry.build

    telemetry.run_started

    assert telemetry, &:recorded_run_started?
  end

  test "Record that a test run finished" do
    telemetry = TestBench::Telemetry.build

    telemetry.run_finished

    assert telemetry, &:recorded_run_finished?
  end

  test "Record that a test failed" do
    result = TestBench::Telemetry.build

    result.test_failed "Some test"

    assert result, &:recorded_test_failed?
  end

  test "Record that a test finished" do
    result = TestBench::Telemetry.build

    result.test_finished "Some test"

    assert result, &:recorded_test_finished?
  end

  test "Record that a test passed" do
    result = TestBench::Telemetry.build

    result.test_passed "Some test"

    assert result, &:recorded_test_passed?
  end

  test "Record that a test was skipped" do
    result = TestBench::Telemetry.build

    result.test_skipped "Some test"

    assert result, &:recorded_test_skipped?
  end

  test "Record that a test started" do
    result = TestBench::Telemetry.build

    result.test_started "Some test"

    assert result, &:recorded_test_started?
  end

  context "Pass/fail results" do
    telemetry = Controls::Telemetry.example

    test "Passed" do
      telemetry.failed = false

      assert telemetry.passed?
      assert !telemetry.failed?
    end

    test "Failed" do
      telemetry.failed = true

      assert !telemetry.passed?
      assert telemetry.failed?
    end
  end

  test "Top level telemetry can be subscribed to" do
    subscriber = Object.new

    observer = TestBench::Telemetry.subscribe subscriber

    toplevel_telemetry = TestBench::Telemetry::Registry.get TOPLEVEL_BINDING
    deleted = toplevel_telemetry.delete_observer observer

    assert deleted

    comment "Some Comment"
  end
end

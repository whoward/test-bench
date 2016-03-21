require_relative './test_init'

context "Result" do
  test "Record that a file was executed" do
    result = TestBench::Result.build

    result.file_finished 'some/file.rb'

    assert result do
      executed? 'some/file.rb'
    end
  end

  test "Record that a test passed" do
    result = TestBench::Result.build

    result.test_passed "Some test"

    assert result, &:recorded_test_passed?
  end

  test "Record that a test failed" do
    result = TestBench::Result.build

    result.test_failed "Some test"

    assert result, &:recorded_test_failed?
  end

  test "Record that an error was raised" do
    result = TestBench::Result.build
    error = Controls::Error.example

    result.error_raised error

    assert result, &:recorded_error_raised?
  end

  test "Record that a test passed" do
    result = TestBench::Result.build

    result.test_passed "Test passed"

    assert result, &:recorded_test_passed?
  end

  test "Record that a test was skipped" do
    result = TestBench::Result.build

    result.test_skipped "Some test"

    assert result, &:recorded_test_skipped?
  end

  test "Record that an assertion was made" do
    result = TestBench::Result.build

    result.asserted

    assert result.assertions == 1
  end

  test "Calculating total number of tests" do
    result = TestBench::Result.build

    result.failures = 1
    result.passes = 2
    result.skips = 3

    assert result.tests == 6
  end

  test "Calculating elapsed time" do
    t0 = Controls::Clock::Elapsed.t0
    t1 = Controls::Clock::Elapsed.t1
    elapsed_time = Controls::Clock::Elapsed.seconds

    result = TestBench::Result.build

    result.start_time = t0
    result.stop_time = t1

    assert result.elapsed_time == elapsed_time
  end

  context "Pass/fail results" do
    passed = Controls::Result::Passed.example
    failed = Controls::Result::Failed.example
    error = Controls::Result::Error.example

    test "Passed" do
      assert passed.passed?
      assert !error.passed?
      assert !failed.passed?
    end

    test "Failed" do
      assert error.failed?
      assert failed.failed?
      assert !passed.failed?
    end
  end
end

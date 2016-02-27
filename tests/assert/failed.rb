require_relative '../test_init'

context "Assertion failed error" do
  file = __FILE__

  test "The backtrace points to the exact location of the assertion" do
    line = __LINE__; error = TestBench::Assert::Failed.build

    first_frame = error.backtrace_locations[0]

    assert first_frame.path == file
    assert first_frame.lineno == line
  end

  test "The error message is helpful" do
    line = __LINE__; error = TestBench::Assert::Failed.build

    message = error.message

    assert message = "Assertion failed (File: #{file.inspect}, Line: #{line})"
  end
end

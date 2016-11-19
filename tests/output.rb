require_relative './test_init'

context "Output" do
  context "An error was raised" do
    error = Controls::Error.example

    test "Error message and stacktrace are rendered in red at the quiet level" do
      control_text = TestBench::Controls::Output::Error.example

      output = TestBench::Output.new
      output.writer.level = :quiet

      output.error_raised error

      assert output.writer do
        raw_text == control_text
      end
    end

    context "Stacktraces are configured to be reversed" do
      test "Stacktrace is reversed" do
        control_text = TestBench::Controls::Output::Error::Reversed.example

        output = TestBench::Output.new
        output.reverse_backtraces = true

        output.error_raised error

        assert output.writer do
          raw_text == control_text
        end
      end
    end
  end

  context "The run has finished" do
    context "Summary" do
      run_result = Controls::Result::Passed.example
      summary = Controls::Output::Summary::Run.example run_result

      test "Rendered at the quiet log level" do
        output = TestBench::Output.new
        output.writer.level = :quiet
        output.run_result = run_result

        output.run_finished

        assert output.writer do
          wrote? summary
        end
      end
    end
  end
end

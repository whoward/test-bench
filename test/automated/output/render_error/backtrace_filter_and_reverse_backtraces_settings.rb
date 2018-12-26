require_relative '../../../test_init'

context "Output" do
  context "Render Error" do
    context "Backtrace Filter And Reverse Backtraces Settings" do
      render_error = TestBench::Output::RenderError.new
      render_error.backtrace_filter = Controls::BacktraceFilter.example
      render_error.reverse_backtraces = true

      error = Controls::Error.example

      output = render_error.(error)

      test do
        assert(output == Controls::Error::Output::Filtered::Reversed.text)
      end
    end
  end
end

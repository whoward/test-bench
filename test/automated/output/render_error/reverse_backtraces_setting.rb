require_relative '../../../test_init'

context "Output" do
  context "Render Error" do
    context "Reverse Backtraces Setting" do
      render_error = TestBench::Output::RenderError.new
      render_error.reverse_backtraces = true

      error = Controls::Error.example

      output = render_error.(error)

      test do
        assert(output == Controls::Error::Output::Reversed.text)
      end
    end
  end
end

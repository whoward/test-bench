require_relative '../../../test_init'

context "Output" do
  context "Render Error" do
    render_error = TestBench::Output::RenderError.new

    error = Controls::Error.example

    output = render_error.(error)

    test do
      assert(output == Controls::Error::Output.text)
    end
  end
end

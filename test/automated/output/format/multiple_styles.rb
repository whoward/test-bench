require_relative '../../../test_init'

context "Output" do
  context "Format" do
    context "Multiple Styles" do
      string = "Some string"

      formatted_string = TestBench::Output::Format.(string, styles: [:bold, :inverse, :underline])

      test "Styles are combined" do
        comment "Example: #{formatted_string}"

        assert(formatted_string == "\e[1;3;4mSome string\e[0m")
      end
    end
  end
end

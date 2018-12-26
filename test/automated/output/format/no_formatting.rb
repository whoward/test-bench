require_relative '../../../test_init'

context "Output" do
  context "Format" do
    context "No Formatting" do
      string = "Some string"

      formatted_string = TestBench::Output::Format.(string)

      test do
        comment "Example: #{formatted_string}"

        assert(formatted_string == string)
      end

      test "String is copied" do
        refute(formatted_string.equal?(string))
      end
    end
  end
end

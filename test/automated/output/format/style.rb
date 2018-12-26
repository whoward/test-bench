require_relative '../../../test_init'

context "Output" do
  context "Format" do
    context "Style" do
      string = "Some string"

      context "Bold" do
        formatted_string = TestBench::Output::Format.(string, style: :bold)

        test do
          comment "Example: #{formatted_string}"

          assert(formatted_string == "\e[1mSome string\e[0m")
        end
      end

      context "Inverse" do
        formatted_string = TestBench::Output::Format.(string, style: :inverse)

        test do
          comment "Example: #{formatted_string}"

          assert(formatted_string == "\e[3mSome string\e[0m")
        end
      end

      context "Underline" do
        formatted_string = TestBench::Output::Format.(string, style: :underline)

        test do
          comment "Example: #{formatted_string}"

          assert(formatted_string == "\e[4mSome string\e[0m")
        end
      end

      context "Strikethrough" do
        formatted_string = TestBench::Output::Format.(string, style: :strikethrough)

        test do
          comment "Example: #{formatted_string}"

          assert(formatted_string == "\e[9mSome string\e[0m")
        end
      end

      context "Multiple Styles" do
        formatted_string = TestBench::Output::Format.(string, styles: [:bold, :underline])

        test do
          comment "Example: #{formatted_string}"

          assert(formatted_string == "\e[1;4mSome string\e[0m")
        end
      end

      context "Invalid" do
        invalid_style = :not_a_style

        begin
          TestBench::Output::Format.(string, style: invalid_style)
        rescue TestBench::Output::Format::LabelError => label_error
        end

        test "Error is raised" do
          refute(label_error.nil?)
        end
      end
    end
  end
end

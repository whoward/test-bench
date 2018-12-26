require_relative '../../../test_init'

context "Output" do
  context "Format" do
    context "Foreground Color" do
      string = "Some string"

      TestBench::Output::Format.color_palette.each_with_index do |color, index|
        context "Color: #{color}" do
          formatted_string = TestBench::Output::Format.(string, fg: color)

          test do
            comment "Example: #{formatted_string}"

            control_string = "\e[3#{index}m#{string}\e[0m"

            assert(formatted_string == control_string)
          end
        end
      end

      context "Invalid" do
        begin
          TestBench::Output::Format.(string, fg: :not_a_color)
        rescue TestBench::Output::Format::LabelError => label_error
        end

        test "Error is raised" do
          refute(label_error.nil?)
        end
      end
    end
  end
end

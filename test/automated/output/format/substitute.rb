require_relative '../../../test_init'

context "Output" do
  context "Format" do
    context "Substitute" do
      substitute = TestBench::Output::Format::Substitute.new

      string = "Some string"

      TestBench::Output::Format.color_palette.each_with_index do |bg_color, bg_index|
        TestBench::Output::Format.color_palette.each_with_index do |fg_color, fg_index|
          styles = TestBench::Output::Format.styles

          context "Color: #{fg_color} on #{bg_color}" do
            formatted_string = substitute.(
              string,
              fg: fg_color,
              bg: bg_color,
              styles: styles
            )

            test do
              assert(formatted_string == string)
            end
          end
        end
      end

      context "No Formatting" do
        string = "Some string"

        formatted_string = substitute.(string)

        test do
          assert(formatted_string == string)
        end

        test "String is copied" do
          refute(formatted_string.equal?(string))
        end
      end

      context "Invalid Color Label" do
        invalid_label = :not_a_color

        context "Foreground" do
          begin
            substitute.(string, fg: invalid_label)
          rescue TestBench::Output::Format::LabelError => label_error
          end

          test "Error is raised" do
            refute(label_error.nil?)
          end
        end

        context "Background" do
          begin
            substitute.(string, bg: invalid_label)
          rescue TestBench::Output::Format::LabelError => label_error
          end

          test "Error is raised" do
            refute(label_error.nil?)
          end
        end
      end

      context "Invalid Style Label" do
        invalid_label = :not_a_style

        context "Background" do
          begin
            substitute.(string, style: invalid_label)
          rescue TestBench::Output::Format::LabelError => label_error
          end

          test "Error is raised" do
            refute(label_error.nil?)
          end
        end
      end
    end
  end
end

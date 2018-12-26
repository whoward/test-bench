require_relative '../../../test_init'

context "Output" do
  context "Format" do
    string = "Some string"

    formatted_string = TestBench::Output::Format.(
      string,
      fg: :white,
      bg: :black,
      styles: [:bold, :underline]
    )

    test do
      comment "Example: #{formatted_string}"

      control_string = "\e[1;4;37;40m#{string}\e[0m"

      assert(formatted_string == control_string)
    end
  end
end

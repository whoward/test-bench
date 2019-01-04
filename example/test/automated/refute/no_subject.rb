require_relative '../automated_init'

context "Refute" do
  context "No Subject" do
    context "Block Omitted" do
      test "Pass/fail result given" do
        x = 11
        y = 111

        refute(x == y)
      end

      test "Pass/fail result not given" do
        # Raises ArgumentError
        refute
      end
    end
  end
end

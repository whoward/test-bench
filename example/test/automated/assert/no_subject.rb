require_relative '../automated_init'

context "Assert" do
  context "No Subject" do
    context "Block Omitted" do
      test "Pass/fail result given" do
        x = 11
        y = 11

        assert(x == y)
      end

      test "Pass/fail result not given" do
        # Raises ArgumentError
        assert
      end
    end
  end
end

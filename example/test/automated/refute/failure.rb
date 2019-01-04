require_relative '../automated_init'

context "Refute" do
  test "Failure" do
    x = 11
    y = 11

    # Raises assertion failure
    refute(x == y)
  end
end

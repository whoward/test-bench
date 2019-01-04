require_relative '../automated_init'

context "Assert" do
  test "Failure" do
    x = 11
    y = 111

    # Raises assertion failure
    assert(x == y)
  end
end

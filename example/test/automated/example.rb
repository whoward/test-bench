require_relative './automated_init'

context "Example" do
  context "Some Inner Context" do
    test "Some passing test" do
      assert(true)
    end

    test "Some failing test" do
      # Raises assertion failure
      assert(false)
    end
  end

  context "Other Inner Context" do
    test "Other passing test" do
      assert(true)
    end

    test "Other failing test" do
      # Raises assertion failure
      assert(false)
    end
  end
end

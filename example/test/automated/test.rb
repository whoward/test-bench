require_relative './automated_init'

# Printed in green to indicate success
test "Passing example" do
  assert(true)
end

# Printed in red to indicate failure
test "Assertion failure example" do
  assert(false)
end

# Printed in red to indicate failure
test "Runtime error example" do
  fail
end

# Comment precedes test prose
test "Test includes a comment" do
  comment "Some comment"

  assert(true)
end

# Displays `Test' in place of the test prose
test do
  assert(true)
end

context "Some Context" do
  # Indented one level
  test "Passing example" do
    assert(true)
  end

  context "Inner Context" do
    # Indented two levels
    test "Passing example" do
      assert(true)
    end
  end
end

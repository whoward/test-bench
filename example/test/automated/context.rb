require_relative './automated_init'

# Not indented
context "Context" do
  # Indented one level
  context "Inner Context" do
    # Indented two levels
    context "Innermost Context" do
      # ...
    end
  end

  # Displays nothing
  context do
    # Indented one level
    context "Inner Context" do
      # ...
    end
  end

  context "Error" do
    # Error is indented
    fail "Example runtime error"
  end
end
# Extra space is printed after outermost context

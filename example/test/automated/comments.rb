require_relative './automated_init'

# Not indented
comment "Some comment"

context "Comments" do
  # Indented one level
  comment "Other comment"

  # Non-strings are inspected
  comment :non_string

  test "Some test" do
    # Indented two levels
    comment "Another comment"

    assert(true)
  end
end

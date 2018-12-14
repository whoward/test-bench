require_relative '../../test_init'

context "Test" do
  context "No Block Argument" do
    return_value = nil

    Controls::Evaluate.() do
      return_value = test "Some skipped test"
    end

    test "Returns false" do
      assert(return_value == false)
    end
  end
end

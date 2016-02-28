require 'test_bench/activate'

context "Outer context" do
  context "Inner context" do
    test "Passing" do
      assert true
    end

    test "Failing" do
      assert false
    end

    test "Error" do
      fail
    end

    test "Other passing" do
      assert true
    end
  end
end

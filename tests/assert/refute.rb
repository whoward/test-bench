require_relative '../test_init'

context "Refute" do
  test "Passing" do
    result = TestBench::Assert::Refute.(false)

    assert result
  end

  test "Failing" do
    result = TestBench::Assert::Refute.(true)

    refute result
  end
end

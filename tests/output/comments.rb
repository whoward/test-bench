require_relative '../test_init'

context "Output, Comments" do
  test "Prose is written at the normal level" do
    output = TestBench::Output.new
    output.writer.level = :normal

    output.commented "Some Comment"

    assert output.writer do
      wrote_line? "Some Comment"
    end
  end

  context "Output level is quiet" do
    output = TestBench::Output.new
    output.writer.level = :quiet

    output.commented "Some Comment"

    test "Nothing is written" do
      assert output.writer, &:wrote_nothing?
    end
  end
end

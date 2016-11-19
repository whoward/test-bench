require_relative '../test_init'

context "Output, Assertions" do
  test "Run result assertion totals are updated" do
    output = TestBench::Output.build
    output.run_result = run_result = TestBench::Result.build

    output.asserted

    assert run_result.assertions == 1
  end

  test "File result assertion totals are updated" do
    output = TestBench::Output.build
    output.file_result = file_result = TestBench::Result.build

    output.asserted

    assert file_result.assertions == 1
  end
end

require_relative '../test_init'

context "Output, Tests" do
  context "Test was started" do
    test "Start of test message is rendered at the verbose level" do
      output = TestBench::Output.new
      output.writer.level = :verbose

      output.test_started "Some test"

      assert output.writer do
        wrote_line? %{Started test "Some test"}
      end
    end

    test "No message is rendered at the normal level" do
      output = TestBench::Output.new
      output.writer.level = :normal

      output.test_started "Some test"

      assert output.writer, &:wrote_nothing?
    end
  end

  context "Test passed" do
    test "Run result total for passing tests is updated" do
      output = TestBench::Output.new

      output.test_passed "Some test"

      assert output.run_result.passes == 1
    end

    test "File result total for passing tests is updated" do
      output = TestBench::Output.new
      output.file_result = file_result = TestBench::Result.build

      output.test_passed "Some test"

      assert file_result.passes == 1
    end

    context "Output" do
      context "Normal level" do
        output = TestBench::Output.new

        output.test_passed "Some test"

        test "Prose is rendered" do
          assert output.writer do
            wrote_line? "Some test"
          end
        end
      end

      context "Quiet level" do
        output = TestBench::Output.new
        output.writer.level = :quiet

        output.test_passed "Some test"

        test "Prose is not rendered" do
          assert output.writer, &:wrote_nothing?
        end
      end
    end
  end

  context "Test failed" do
    test "Run result total for failing tests is updated" do
      output = TestBench::Output.new

      output.test_failed "Some test"

      assert output.run_result.failures == 1
    end

    test "File result total for failing tests is updated" do
      output = TestBench::Output.new
      output.file_result = file_result = TestBench::Result.build

      output.test_failed "Some test"

      assert file_result.failures == 1
    end

    context "Output" do
      context "Quiet level" do
        output = TestBench::Output.new
        output.writer.level = :quiet

        output.test_failed "Some test"

        test "Prose is rendered" do
          assert output.writer do
            wrote_line? "Some test"
          end
        end
      end
    end
  end

  context "Test was skipped" do
    test "Run result total for skipped tests is updated" do
      output = TestBench::Output.new

      output.test_skipped "Some test"

      assert output.run_result.skips == 1
    end

    test "File result total for skipped tests is updated" do
      output = TestBench::Output.new
      output.file_result = file_result = TestBench::Result.build

      output.test_skipped "Some test"

      assert file_result.skips == 1
    end

    context "Output" do
      context "Normal level" do
        output = TestBench::Output.new
        output.writer.level = :normal

        output.test_skipped "Some test"

        test "Prose is rendered" do
          assert output.writer do
            wrote_line? "Some test"
          end
        end
      end

      context "Quiet level" do
        output = TestBench::Output.new
        output.writer.level = :quiet

        output.test_skipped "Some test"

        test "Prose is not rendered" do
          assert output.writer, &:wrote_nothing?
        end
      end
    end
  end
end

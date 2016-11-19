require_relative '../test_init'

context "Output, Files" do
  context "File has started executing" do
    path = Controls::Path.example

    context "Message that the file is running" do
      test "Rendered at the normal output level" do
        output = TestBench::Output.new
        output.writer.level = :normal

        output.file_started path

        assert output.writer do
          wrote? "Running #{path}\n"
        end
      end

      test "Not rendered at the quiet output level" do
        output = TestBench::Output.new
        output.writer.level = :quiet

        output.file_started path

        assert output, &:wrote_nothing?
      end
    end

    test "Current file result is set" do
      output = TestBench::Output.new
      original_file_result = output.file_result

      output.file_started path

      refute output.file_result == original_file_result
    end
  end

  context "File has finished executing" do
    path = Controls::Path.example

    test "Run result is updated to include file" do
      output = TestBench::Output.new

      output.file_started path
      output.file_finished path

      assert output.run_result.files == [path]
    end

    context "Current file result" do
      test "Stop time is recorded" do
        output = TestBench::Output.new
        file_result = output.file_started path

        output.file_finished path

        assert file_result.stop_time
      end

      test "Is reset" do
        output = TestBench::Output.new
        output.file_result = file_result = TestBench::Result.build

        output.file_finished path

        refute output.file_result == file_result
      end

      context "Summary" do
        file_result = Controls::Result.example
        summary = Controls::Output::Summary::File.example file_result

        test "Rendered at the verbose output level" do
          output = TestBench::Output.new
          output.writer.level = :verbose
          output.file_result = file_result

          output.file_finished path

          assert output.writer do
            wrote? summary
          end
        end

        test "Not rendered at the normal output level" do
          output = TestBench::Output.new
          output.writer.level = :normal
          output.file_result = file_result

          output.file_finished path

          assert output, &:wrote_nothing?
        end
      end
    end
  end
end

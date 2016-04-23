require_relative './test_init'

context "Output" do
  context "Assertion was made" do
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

  context "Context was entered" do
    test "Prose is written at the normal level" do
      output = TestBench::Output.new
      output.writer.level = :normal

      output.context_entered "Some Context"

      assert output.writer do
        wrote_line? "Some Context"
      end
    end

    context "Indentation" do
      output = TestBench::Output.new

      output.context_entered "Some Context"

      test "Level is increased" do
        assert output.writer.indentation == 1
      end
    end

    context "Output level is quiet" do
      output = TestBench::Output.new
      output.writer.level = :quiet

      output.context_entered "Some Context"

      test "Nothing is written" do
        assert output.writer, &:wrote_nothing?
      end

      test "Indentation is unchanged" do
        assert output.writer.indentation == 0
      end
    end

    context "Prose is not supplied" do
      output = TestBench::Output.new
      output.writer.level = :normal
      output.context_entered

      test "Nothing is written" do
        assert output, &:wrote_nothing?
      end

      test "Indentation is unchanged" do
        assert output.writer.indentation == 0
      end
    end
  end

  context "Context was exited" do
    context "Outer context was exited" do
      output = TestBench::Output.new
      output.writer.level = :normal
      output.writer.indentation = 1

      output.context_exited "Some Context"

      test "Indentation is decreased" do
        assert output.writer.indentation == 0
      end

      test "A blank line is written" do
        assert output.writer do
          wrote_line? ' '
        end
      end
    end

    context "Inner context was exited" do
      output = TestBench::Output.new
      output.writer.indentation = 2

      output.context_exited "Inner Context"

      test "A blank line is not written" do
        refute output.writer do
          wrote_line? ' '
        end
      end
    end

    context "Output level is quiet" do
      output = TestBench::Output.new
      output.writer.level = :quiet
      output.writer.indentation = 1

      output.context_exited

      test "Indentation is unchanged" do
        assert output.writer.indentation == 1
      end
    end

    context "Prose is not supplied" do
      output = TestBench::Output.new
      output.writer.indentation = 1

      output.context_exited

      test "Indentation is unchanged" do
        assert output.writer.indentation == 1
      end
    end
  end

  context "An error was raised" do
    error = Controls::Error.example

    test "Error message and stacktrace are rendered in red at the quiet level" do
      control_text = TestBench::Controls::Output::Error.example

      output = TestBench::Output.new
      output.writer.level = :quiet

      output.error_raised error

      assert output.writer do
        raw_text == control_text
      end
    end

    context "Stacktraces are configured to be reversed" do
      test "Stacktrace is reversed" do
        control_text = TestBench::Controls::Output::Error::Reversed.example

        output = TestBench::Output.new
        output.reverse_backtraces = true

        output.error_raised error

        assert output.writer do
          raw_text == control_text
        end
      end
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

  context "The run has finished" do
    context "Summary" do
      run_result = Controls::Result::Passed.example
      summary = Controls::Output::Summary::Run.example run_result

      test "Rendered at the quiet log level" do
        output = TestBench::Output.new
        output.writer.level = :quiet
        output.run_result = run_result

        output.run_finished

        assert output.writer do
          wrote? summary
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
end

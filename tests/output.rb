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

  context "Coloring" do
    context "Explicitly set" do
      test "Enabled" do
        output = TestBench::Output.build

        output.device = Controls::Output::Device.non_tty
        output.color = true

        assert output, &:color_output?
      end

      test "Disabled" do
        output = TestBench::Output.build

        output.device = Controls::Output::Device.tty
        output.color = false

        refute output, &:color_output?
      end
    end

    context "Auto detection" do
      test "Enabled for instances of StringIO" do
        output = TestBench::Output.build

        output.device = StringIO.new

        assert output, &:color_output?
      end

      test "Device is a teletype interface (tty)" do
        output = TestBench::Output.build

        output.device = Controls::Output::Device.tty

        assert output, &:color_output?
      end

      test "Device is not a teletype interface (tty)" do
        output = TestBench::Output.build 

        output.device = Controls::Output::Device.non_tty

        refute output, &:color_output?
      end
    end
  end

  context "Context was entered" do
    test "Prose is written at the normal level in green" do
      output = TestBench::Output.new :normal

      output.context_entered "Some Context"

      assert output do
        wrote_line? "Some Context", :fg => :green
      end
    end

    context "Indentation" do
      output = TestBench::Output.new :normal
      output.context_entered "Some Context"

      test "Next line of output is indented" do
        output.write "Some text"

        assert output do
          wrote_line? "  Some text"
        end
      end

      test "Level is increased" do
        assert output.indentation == 1
      end
    end

    context "Output level is quiet" do
      output = TestBench::Output.new :quiet
      output.context_entered "Some Context"

      test "Nothing is written" do
        assert output, &:wrote_nothing?
      end

      test "Indentation is unchanged" do
        assert output.indentation == 0
      end
    end

    context "Prose is not supplied" do
      output = TestBench::Output.new :normal
      output.context_entered

      test "Nothing is written" do
        assert output, &:wrote_nothing?
      end

      test "Indentation is unchanged" do
        assert output.indentation == 0
      end
    end
  end

  context "Context was exited" do
    context "Outer context was exited" do
      output = TestBench::Output.new :normal
      output.indentation = 1

      output.context_exited "Some Context"

      test "Indentation is decreased" do
        assert output.indentation == 0
      end

      test "A blank line is written" do
        assert output do
          wrote_line? ' '
        end
      end
    end

    context "Inner context was exited" do
      output = TestBench::Output.new :normal
      output.indentation = 2

      output.context_exited "Inner Context"

      test "A blank line is not written" do
        refute output do
          wrote_line? ' '
        end
      end
    end

    context "Output level is quiet" do
      output = TestBench::Output.new :quiet
      output.indentation = 1

      output.context_exited

      test "Indentation is unchanged" do
        assert output.indentation == 1
      end
    end

    context "Prose is not supplied" do
      output = TestBench::Output.new :normal
      output.indentation = 1

      output.context_exited

      test "Indentation is unchanged" do
        assert output.indentation == 1
      end
    end
  end

  context "An error was raised" do
    test "Error message and stacktrace are rendered in red at the quiet level" do
      error = Controls::Error.example
      output = TestBench::Output.new :quiet
      control_text_written = TestBench::Controls::Output::Error.example

      output.error_raised error

      assert output do
        text_written == control_text_written
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
          output = TestBench::Output.new :verbose
          output.color = false
          output.file_result = file_result

          output.file_finished path

          assert output do
            wrote? summary
          end
        end

        test "Not rendered at the normal output level" do
          output = TestBench::Output.new :normal
          output.color = false
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
        output = TestBench::Output.new :normal

        output.file_started path

        assert output do
          wrote? "Running #{path}\n"
        end
      end

      test "Not rendered at the quiet output level" do
        output = TestBench::Output.new :quiet

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

  context "Adjusting verbosity" do
    context "Lowering" do
      test "From verbose to normal" do
        output = TestBench::Output.new :verbose

        output.lower_verbosity

        assert output.level == :normal
      end

      test "From normal to quiet" do
        output = TestBench::Output.new :normal

        output.lower_verbosity

        assert output.level == :quiet
      end

      test "From quiet to quiet" do
        output = TestBench::Output.new :quiet

        output.lower_verbosity

        assert output.level == :quiet
      end
    end

    context "Raising" do
      test "From quiet to normal" do
        output = TestBench::Output.new :quiet

        output.raise_verbosity

        assert output.level == :normal
      end

      test "From normal to verbose" do
        output = TestBench::Output.new :normal

        output.raise_verbosity

        assert output.level == :verbose
      end

      test "From verbose to verbose" do
        output = TestBench::Output.new :verbose

        output.raise_verbosity

        assert output.level == :verbose
      end
    end
  end

  context "The run has finished" do
    context "Summary" do
      run_result = Controls::Result::Passed.example
      summary = Controls::Output::Summary::Run.example run_result

      test "Rendered at the quiet log level" do
        output = TestBench::Output.new :quiet
        output.run_result = run_result
        output.color = false

        output.run_finished

        assert output do
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
        output = TestBench::Output.new :quiet

        output.test_failed "Some test"

        test "Prose is rendered in white on red" do
          assert output do
            wrote_line? "Some test", :fg => :white, :bg => :red
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
        output = TestBench::Output.new :normal

        output.test_passed "Some test"

        test "Prose is rendered in green" do
          assert output do
            wrote_line? "Some test", :fg => :green
          end
        end
      end

      context "Quiet level" do
        output = TestBench::Output.new :quiet

        output.test_passed "Some test"

        test "Prose is not rendered" do
          assert output, &:wrote_nothing?
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
        output = TestBench::Output.new :normal

        output.test_skipped "Some test"

        test "Prose is rendered in brown" do
          assert output do
            wrote_line? "Some test", :fg => :brown
          end
        end
      end

      context "Quiet level" do
        output = TestBench::Output.new :quiet

        output.test_skipped "Some test"

        test "Prose is not rendered" do
          assert output, &:wrote_nothing?
        end
      end
    end
  end
end

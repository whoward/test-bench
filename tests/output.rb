require_relative './test_init'

context "Output" do
  test "File has begun being executed" do
    output = TestBench::Output.new :normal
    path = Controls::Path.example

    output.file_started path

    assert output do
      wrote_line? "Running #{path}"
    end
  end

  context "Context step was entered" do
    test do
      output = TestBench::Output.new :normal

      output.context_entered "Some context"

      assert output do
        wrote_line? "Some context", :fg => :green
      end
    end

    context "Indentation is increased" do
      test do
        output = TestBench::Output.new :normal

        output.context_entered "Some context"

        assert output.indentation == 1
      end

      test "Unless output is in quiet mode" do
        output = TestBench::Output.new :quiet

        output.context_entered "Some context"

        assert output.indentation == 0
      end
    end

    context "No prose given" do
      test do
        output = TestBench::Output.new :normal

        output.context_entered nil

        assert output, &:wrote_nothing?
      end

      test "Indentation is not increased" do
        output = TestBench::Output.new :normal

        output.context_entered nil

        assert output.indentation == 0
      end
    end
  end

  context "Context step was exited" do
    test do
      output = TestBench::Output.new :normal

      output.context_exited "Some context"

      assert output, &:wrote_nothing?
    end

    context "Indentation is decreased" do
      test do
        output = TestBench::Output.new :normal
        output.indentation = 1

        output.context_exited "Some context"

        assert output.indentation == 0
      end

      test "Unless output is in quiet mode" do
        output = TestBench::Output.new :quiet
        output.indentation = 1

        output.context_exited "Some context"

        assert output.indentation == 1
      end
    end

    context "No prose given" do
      test "Indentation is not decreased" do
        output = TestBench::Output.new :normal
        output.indentation = 1

        output.context_exited nil
        output.context_entered "Inner context"

        assert output do
          wrote_line? "Inner context", :fg => :green, :indent => 1
        end
      end
    end
  end

  test "Test was started" do
    output = TestBench::Output.new :verbose

    output.test_started "Some test"

    assert output do
      wrote_line? %{Started test "Some test"}, :fg => :gray
    end
  end

  test "Test passed" do
    output = TestBench::Output.new :normal

    output.test_passed "Some test"

    assert output do
      wrote_line? "Some test", :fg => :green
    end
  end

  test "Test failed" do
    output = TestBench::Output.new :normal

    output.test_failed "Some test"

    assert output do
      wrote_line? "Some test", :fg => :white, :bg => :red
    end
  end

  test "Test skipped" do
    output = TestBench::Output.new :normal

    output.test_skipped "Some test"

    assert output do
      wrote_line? "Some test", :fg => :brown
    end
  end

  test "An error was raised" do
    error = Controls::Error.example
    output = TestBench::Output.new :quiet
    control_text_written = TestBench::Controls::Error.detail :fg => :red

    output.error_raised error

    assert output do
      text_written == control_text_written
    end
  end

  context "File has finished being executed" do
    output = TestBench::Output.new :verbose
    path = Controls::Path.example
    telemetry = Controls::Telemetry.example

    output.file_finished path, telemetry

    test "File finished" do
      assert output do
        wrote_line? "Finished running #{path}"
      end
    end

    test "Telemetry summary" do
      control_summary = Controls::Telemetry::Summary.example telemetry

      assert output do
        wrote_line? control_summary
      end
    end
  end

  context "The run has finished" do
    output = TestBench::Output.new :quiet
    telemetry = Controls::Telemetry.example

    output.run_finished telemetry

    test "Run finished" do
      assert output do
        wrote_line? "Finished running 1 file", :fg => :cyan
      end
    end

    test "Telemetry summary" do
      control_summary = Controls::Telemetry::Summary.example telemetry

      assert output do
        wrote_line? control_summary, :fg => :cyan
      end
    end
  end
end

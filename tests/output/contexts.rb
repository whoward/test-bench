require_relative '../test_init'

context "Output, Contexts" do
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
end

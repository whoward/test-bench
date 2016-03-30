require_relative '../test_init'

context "Output writer" do
  context "Indentation" do
    test "Increasing" do
      writer = TestBench::Output::Writer.new

      writer.increase_indentation
      writer.write "Some message"

      assert writer.device.string == "  Some message\n"
    end

    test "Decreasing" do
      writer = TestBench::Output::Writer.new

      writer.increase_indentation
      writer.decrease_indentation
      writer.write "Some message"

      assert writer.device.string == "Some message\n"
    end
  end

  context "Verbosity" do
    context "Verbose level" do
      test "Renders verbose messages" do
        writer = TestBench::Output::Writer.new :verbose

        writer.verbose "Some message"

        assert writer.device.string == "Some message\n"
      end

      test "Renders normal messages" do
        writer = TestBench::Output::Writer.new :verbose

        writer.normal "Some message"

        assert writer.device.string == "Some message\n"
      end

      test "Renders quiet messages" do
        writer = TestBench::Output::Writer.new :verbose

        writer.quiet "Some message"

        assert writer.device.string == "Some message\n"
      end

      test "Raising verbosity has no effect" do
        writer = TestBench::Output::Writer.new :verbose

        writer.raise_verbosity

        assert writer.level == :verbose
      end

      test "Lowering verbosity changes level to normal" do
        writer = TestBench::Output::Writer.new :verbose

        writer.lower_verbosity

        assert writer.level == :normal
      end
    end

    context "Normal level" do
      test "Does not render verbose messages" do
        writer = TestBench::Output::Writer.new :normal

        writer.verbose "Some message"

        assert writer.device.string == ""
      end

      test "Renders normal messages" do
        writer = TestBench::Output::Writer.new :normal

        writer.normal "Some message"

        assert writer.device.string == "Some message\n"
      end

      test "Renders quiet messages" do
        writer = TestBench::Output::Writer.new :normal

        writer.quiet "Some message"

        assert writer.device.string == "Some message\n"
      end

      test "Raising verbosity changes level to verbose" do
        writer = TestBench::Output::Writer.new :normal

        writer.raise_verbosity

        assert writer.level == :verbose
      end

      test "Lowering verbosity changes level to quiet" do
        writer = TestBench::Output::Writer.new :normal

        writer.lower_verbosity

        assert writer.level == :quiet
      end
    end

    context "Quiet level" do
      test "Does not render verbose messages" do
        writer = TestBench::Output::Writer.new :quiet

        writer.verbose "Some message"

        assert writer.device.string == ""
      end

      test "Does not render normal messages" do
        writer = TestBench::Output::Writer.new :quiet

        writer.normal "Some message"

        assert writer.device.string == ""
      end

      test "Renders quiet messages" do
        writer = TestBench::Output::Writer.new :quiet

        writer.quiet "Some message"

        assert writer.device.string == "Some message\n"
      end


      test "Raising verbosity changes level to normal" do
        writer = TestBench::Output::Writer.new :quiet

        writer.raise_verbosity

        assert writer.level == :normal
      end

      test "Lowering verbosity has no effect" do
        writer = TestBench::Output::Writer.new :quiet

        writer.lower_verbosity

        assert writer.level == :quiet
      end
    end
  end

  context "Coloring" do
    colored_output = "\e[1;33;44mSome message\e[0m\n"
    noncolored_output = "Some message\n"

    context "Auto detected" do
      test "Device is a teletype interface (tty)" do
        device = Controls::Output::Device.tty
        writer = TestBench::Output::Writer.build device

        writer.write "Some message", :fg => :yellow, :bg => :blue

        output = writer.device.tap(&:rewind).read
        assert output == colored_output
      end

      test "Device is not a teletype interface (tty)" do
        device = Controls::Output::Device.non_tty
        writer = TestBench::Output::Writer.build device

        writer.write "Some message", :fg => :yellow, :bg => :blue

        output = writer.device.tap(&:rewind).read
        assert output == noncolored_output
      end
    end

    context "Set explicitly" do
      test "Enabling activates color even if device is not a teletype interface (tty)" do
        device = Controls::Output::Device.non_tty
        writer = TestBench::Output::Writer.build device
        writer.color = true

        writer.write "Some message", :fg => :yellow, :bg => :blue

        output = writer.device.tap(&:rewind).read
        assert output == colored_output
      end

      test "Disabling deactivates color even if device is a teletype interface (tty)" do
        device = Controls::Output::Device.tty
        writer = TestBench::Output::Writer.build device
        writer.color = false

        writer.write "Some message", :fg => :yellow, :bg => :blue

        output = writer.device.tap(&:rewind).read
        assert output == noncolored_output
      end
    end
  end

  context "Assertions" do
    test "Comparing raw text" do
      writer = TestBench::Output::Writer.new

      writer.write "Some message"
      writer.write "Some other message"

      assert writer do
        wrote? <<~TEXT
        Some message
        Some other message
        TEXT
      end
    end

    context "Matching a line of text" do
      context "Ignoring color" do
        writer = TestBench::Output::Writer.new
        writer.color = true

        writer.write "Some message", :fg => :brown, :bg => :blue

        assert writer do
          wrote_line? "Some message"
        end
      end

      context "Foreground color" do
        context "Output color is expected to match" do
          context "Match" do
            writer = TestBench::Output::Writer.new
            writer.color = true

            writer.write "Some message", :fg => :brown

            assert writer do
              wrote_line? "Some message", :fg => :brown
            end
          end

          context "Non match" do
            writer = TestBench::Output::Writer.new
            writer.color = true

            writer.write "Some message", :fg => :brown

            test "Different color" do
              refute writer do
                wrote_line? "Some message", :fg => :red
              end
            end

            test "Different brightness" do
              refute writer do
                wrote_line? "Some message", :fg => :yellow
              end
            end

            test "Expected no color" do
              refute writer do
                wrote_line? "Some message", :fg => nil
              end
            end
          end
        end
      end

      context "Background color" do
        context "Output color is expected to match" do
          context "Match" do
            writer = TestBench::Output::Writer.new
            writer.color = true

            writer.write "Some message", :bg => :blue

            assert writer do
              wrote_line? "Some message", :bg => :blue
            end
          end

          context "Non match" do
            writer = TestBench::Output::Writer.new
            writer.color = true

            writer.write "Some message", :bg => :blue

            test "Different color" do
              refute writer do
                wrote_line? "Some message", :bg => :red
              end
            end

            test "Expected no color" do
              refute writer do
                wrote_line? "Some message", :bg => nil
              end
            end
          end
        end
      end

      context "Testing indentation" do
        test do
          writer = TestBench::Output::Writer.new

          writer.write "  Some message"

          assert writer do
            wrote_line? "Some message", :indentation => 1
          end
        end

        test "Output includes color escape codes" do
          writer = TestBench::Output::Writer.new

          writer.write "  Some message", :fg => :brown

          assert writer do
            wrote_line? "Some message", :indentation => 1
          end
        end

        test "Indentation is ignored" do
          writer = TestBench::Output::Writer.new

          writer.write "  Some message", :fg => :brown

          assert writer do
            wrote_line? "Some message"
          end
        end
      end
    end
  end
end

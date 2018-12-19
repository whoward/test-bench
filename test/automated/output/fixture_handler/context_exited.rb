require_relative '../../../test_init'

context "Fixture Handler" do
  context "Context Exited" do
    context "Prose" do
      context_exited = Controls::Telemetry::Record::ContextExited.example

      context "Outermost Context" do
        fixture_handler = TestBench::Output::Handlers::Fixture.new
        fixture_handler.indentation = 1

        fixture_handler.handle(context_exited)

        device = fixture_handler.device

        test "Blank line is written to device" do
          assert(device.string == "\n")
        end

        test "Indentation is decreased" do
          assert(fixture_handler.indentation == 0)
        end
      end

      context "Inner Context" do
        fixture_handler = TestBench::Output::Handlers::Fixture.new
        fixture_handler.indentation = 2

        fixture_handler.handle(context_exited)

        device = fixture_handler.device

        test "Nothing is written to device" do
          assert(device.string.empty?)
        end

        test "Indentation is decreased" do
          assert(fixture_handler.indentation == 1)
        end
      end
    end

    context "No Prose" do
      fixture_handler = TestBench::Output::Handlers::Fixture.new

      context_exited = Controls::Telemetry::Record::ContextExited.example(prose: :none)
      assert(context_exited.prose.nil?)

      previous_indentation = fixture_handler.indentation or fail

      fixture_handler.handle(context_exited)

      device = fixture_handler.device

      test "Nothing is written to device" do
        assert(device.string.empty?)
      end

      test "Indentation is unchanged" do
        indentation = fixture_handler.indentation

        assert(indentation == previous_indentation)
      end
    end
  end
end

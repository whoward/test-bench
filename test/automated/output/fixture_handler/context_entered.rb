require_relative '../../../test_init'

context "Fixture Handler" do
  context "Context Entered" do
    context "Prose" do
      context_entered = Controls::Telemetry::Record::ContextEntered.example

      context do
        fixture_handler = TestBench::Output::Handlers::Fixture.new

        previous_indentation = fixture_handler.indentation or fail

        fixture_handler.handle(context_entered)

        device = fixture_handler.device

        test "Prose is written to device" do
          assert(device.string == "#{context_entered.prose}\n")
        end

        test "Indentation is increased" do
          indentation = fixture_handler.indentation

          assert(indentation == previous_indentation + 1)
        end
      end

      context "Indentation" do
        fixture_handler = TestBench::Output::Handlers::Fixture.new
        fixture_handler.indentation = 1

        previous_indentation = fixture_handler.indentation or fail

        fixture_handler.handle(context_entered)

        device = fixture_handler.device

        test "Prose is indented" do
          assert(device.string.match?(/[[:blank:]]+#{context_entered.prose}/))
        end
      end
    end

    context "No Prose" do
      fixture_handler = TestBench::Output::Handlers::Fixture.new

      context_entered = Controls::Telemetry::Record::ContextEntered.example(prose: :none)
      assert(context_entered.prose.nil?)

      previous_indentation = fixture_handler.indentation or fail

      fixture_handler.handle(context_entered)

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

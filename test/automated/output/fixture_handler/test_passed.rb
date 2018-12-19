require_relative '../../../test_init'

context "Fixture Handler" do
  context "Test Passed" do
    context "Prose" do
      test_passed = Controls::Telemetry::Record::TestPassed.example

      context do
        fixture_handler = TestBench::Output::Handlers::Fixture.new

        fixture_handler.handle(test_passed)

        device = fixture_handler.device

        test "Prose is written to device" do
          assert(device.string == "#{test_passed.prose}\n")
        end
      end

      context "Indentation" do
        fixture_handler = TestBench::Output::Handlers::Fixture.new
        fixture_handler.indentation = 1

        fixture_handler.handle(test_passed)

        device = fixture_handler.device

        test "Prose is indented" do
          assert(device.string.match?(/[[:blank:]]+#{test_passed.prose}/))
        end
      end
    end

    context "No Prose" do
      fixture_handler = TestBench::Output::Handlers::Fixture.new

      test_passed = Controls::Telemetry::Record::TestPassed.example(prose: :none)
      assert(test_passed.prose.nil?)

      fixture_handler.handle(test_passed)

      device = fixture_handler.device

      test "`Test' is written to device" do
        assert(device.string == "Test\n")
      end
    end
  end
end

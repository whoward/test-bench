require_relative '../../../test_init'

context "Fixture Handler" do
  context "Commented" do
    commented = Controls::Telemetry::Record::Commented.example

    context do
      fixture_handler = TestBench::Output::Handlers::Fixture.new

      fixture_handler.handle(commented)

      device = fixture_handler.device

      test "Prose is written to device" do
        assert(device.string == "#{commented.prose}\n")
      end
    end

    context "Indentation" do
      fixture_handler = TestBench::Output::Handlers::Fixture.new
      fixture_handler.indentation = 1

      fixture_handler.handle(commented)

      device = fixture_handler.device

      test "Prose is indented" do
        assert(device.string.match?(/[[:blank:]]+#{commented.prose}/))
      end
    end
  end
end

require_relative '../../../test_init'

context "Output" do
  context "Fixture Handler" do
    context "Error Raised" do
      error_raised = Controls::Telemetry::Record::ErrorRaised.example

      context do
        fixture_handler = TestBench::Output::Handlers::Fixture.new

        fixture_handler.handle(error_raised)

        device = fixture_handler.device

        test "Error backtrace is written to device" do
          backtrace_text = Controls::Error::Output.text

          assert(device.string == backtrace_text)
        end
      end

      context "Indentation" do
        fixture_handler = TestBench::Output::Handlers::Fixture.new
        fixture_handler.indentation = 1

        fixture_handler.handle(error_raised)

        device = fixture_handler.device

        test "Each line is indented" do
          indented = Controls::Error::Backtrace.example.all? do |entry|
            device.string.match?(/[[:blank:]]+#{Regexp.escape(entry)}/)
          end

          assert(indented)
        end
      end
    end
  end
end

require_relative '../../../test_init'

context "Telemetry" do
  context "Handler" do
    context "Handles Record" do
      handler = Controls::Telemetry::Handler.example

      record = Controls::Telemetry::Record.example

      handler.handle(record)

      test "Record is handled" do
        assert(handler.handled?(record))
      end
    end

    context "Does Not Handle Record" do
      handler = Controls::Telemetry::Handler.example

      record = Controls::Telemetry::Record.alternate

      handler.handle(record)

      test "Record is not handled" do
        refute(handler.handled?(record))
      end
    end
  end
end

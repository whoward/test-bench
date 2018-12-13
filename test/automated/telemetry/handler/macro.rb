require_relative '../../../test_init'

context "Telemetry" do
  context "Handler" do
    context "Macro" do
      context "Block Given" do
        handler = Controls::Telemetry::Handler.example

        test "Handler method is defined" do
          assert(handler.respond_to?(:handle_some_signal))
        end
      end

      context "Block Omitted" do
        begin
          Class.new do
            include TestBench::Telemetry::Handler

            handle Controls::Telemetry::Record::Example
          end
        rescue ArgumentError => error
        end

        test "Raises argument error" do
          refute(error.nil?)
        end
      end
    end
  end
end

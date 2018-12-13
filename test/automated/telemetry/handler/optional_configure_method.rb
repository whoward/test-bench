require_relative '../../../test_init'

context "Telemetry" do
  context "Handler" do
    context "Optional Configure Method" do
      context "Present" do
        handler = Controls::Telemetry::Handler::Example.build

        test "Method is invoked" do
          assert(handler.configured?)
        end
      end

      context "Omitted" do
        handler_class = Controls::Telemetry::Handler.example_class

        begin
          handler = handler_class.build
        rescue => error
        end

        test "No error is raised" do
          assert(error.nil?)
        end
      end
    end
  end
end

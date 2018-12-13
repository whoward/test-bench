require_relative '../../../test_init'

context "Telemetry" do
  context "Handler" do
    context "Settings" do
      settings = Controls::Settings.example(abort_on_error: true)

      handler = Controls::Telemetry::Handler::Example.build(settings)

      test "Setting is set" do
        assert(handler.abort_on_error == true)
      end
    end
  end
end

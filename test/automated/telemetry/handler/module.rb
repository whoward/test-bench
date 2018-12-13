require_relative '../../../test_init'

context "Telemetry" do
  context "Handler" do
    context "Module" do
      cls = Controls::Telemetry::Handler::Example

      [
        #TestBench::Assert::Telemetry,
        #TestBench::Comment::Telemetry,
        #TestBench::Context::Telemetry,
        #TestBench::Test::Telemetry
      ].each do |telemetry_namespace|
        context "Telemetry Namespace: #{telemetry_namespace}" do
          test "Included in handler class" do
            assert(cls.included_modules.include?(telemetry_namespace))
          end
        end
      end
    end
  end
end

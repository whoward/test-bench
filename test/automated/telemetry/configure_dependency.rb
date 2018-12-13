require_relative '../../test_init'

context "Output" do
  context "Telemetry" do
    context "Configure Dependency" do
      context "Attribute Name Omitted" do
        receiver = OpenStruct.new

        TestBench::Telemetry.configure(receiver)

        test "Telemetry attribute is configured" do
          assert(receiver.telemetry.instance_of?(TestBench::Telemetry))
        end
      end

      context "Attribute Name Given" do
        receiver = OpenStruct.new

        TestBench::Telemetry.configure(receiver, attr_name: :some_attr)

        test "Given attribute is configured" do
          assert(receiver.some_attr.instance_of?(TestBench::Telemetry))
        end
      end
    end
  end
end

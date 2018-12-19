require_relative '../../../test_init'

context "Output" do
  context "Device" do
    context "Configure Dependency" do
      context "Attribute Name Omitted" do
        receiver = OpenStruct.new

        TestBench::Output::Device.configure(receiver)

        test "Device attribute is set to stdout" do
          assert(receiver.device == $stdout)
        end
      end

      context "Attribute Name Given" do
        receiver = OpenStruct.new

        TestBench::Output::Device.configure(receiver, attr_name: :some_attr)

        test "Given attribute is set to stdout" do
          assert(receiver.some_attr == $stdout)
        end
      end

      context "Optional Device Given" do
        device = StringIO.new

        receiver = OpenStruct.new

        TestBench::Output::Device.configure(receiver, device: device)

        test "Device attribute is set to given device" do
          assert(receiver.device == device)
        end
      end
    end
  end
end

require_relative '../../../test_init'

context "Output" do
  context "Format" do
    context "Configure Dependency" do
      context "Attribute Name Omitted" do
        receiver = OpenStruct.new

        TestBench::Output::Format.configure(receiver)

        test "Format attribute is configured" do
          assert(receiver.format.instance_of?(TestBench::Output::Format))
        end
      end

      context "Attribute Name Given" do
        receiver = OpenStruct.new

        TestBench::Output::Format.configure(receiver, attr_name: :some_attr)

        test "Given attribute is configured" do
          assert(receiver.some_attr.instance_of?(TestBench::Output::Format))
        end
      end
    end
  end
end

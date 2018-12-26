require_relative '../../../test_init'

context "Output" do
  context "Render Error" do
    context "Configure Dependency" do
      context "Attribute Name Omitted" do
        receiver = OpenStruct.new

        TestBench::Output::RenderError.configure(receiver)

        test "Render error attribute is configured" do
          assert(receiver.render_error.instance_of?(TestBench::Output::RenderError))
        end
      end

      context "Attribute Name Given" do
        receiver = OpenStruct.new

        TestBench::Output::RenderError.configure(receiver, attr_name: :some_attr)

        test "Given attribute is configured" do
          assert(receiver.some_attr.instance_of?(TestBench::Output::RenderError))
        end
      end
    end
  end
end

require_relative '../../../test_init'

context "Settings" do
  context "Setting Macro" do
    setting_name = Controls::Settings::Name.example

    receiver = Controls::Settings::Receiver.example do
      setting setting_name
    end

    context "Generated Attribute" do
      test "Setter is defined" do
        assert(receiver.respond_to?("#{setting_name}="))
      end

      test "Getter is defined" do
        assert(receiver.respond_to?(setting_name))
      end
    end
  end
end

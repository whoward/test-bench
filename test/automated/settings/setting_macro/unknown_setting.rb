require_relative '../../../test_init'

context "Settings" do
  context "Setting Macro" do
    context "Unknown Setting" do
      setting_name = Controls::Settings::Name::Anomaly.example

      begin
        Controls::Settings::Receiver.example_class do
          setting setting_name
        end
      rescue TestBench::Settings::SettingMacro::Error => error
      end

      test "Raises error" do
        refute(error.nil?)
      end
    end
  end
end

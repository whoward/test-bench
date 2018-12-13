require_relative '../../test_init'

context "Settings" do
  context "Set" do
    setting_1 = Controls::Settings::Name.example
    setting_2 = Controls::Settings::Name.alternate

    settings = Controls::Settings.example({
      setting_1 => :some_value,
      setting_2 => :other_value
    })

    refute(settings.public_send(setting_1).nil?)
    refute(settings.public_send(setting_2).nil?)

    receiver = Controls::Settings::Receiver.example do
      setting setting_1
      setting setting_2
    end

    settings.set(receiver)

    setting_1_value = receiver.public_send(setting_1)
    setting_2_value = receiver.public_send(setting_2)

    test "Setting attributes on receiver are copied from settings" do
      assert(setting_1_value == settings.public_send(setting_1))
      assert(setting_2_value == settings.public_send(setting_2))
    end
  end
end

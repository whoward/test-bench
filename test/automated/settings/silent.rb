require_relative '../../test_init'

context "Settings" do
  context "Silent" do
    Test::Fixtures::Settings::Setting::Boolean.(
      setting: :silent,
      default_value: false,
      env_var: 'TEST_BENCH_SILENT'
    )
  end
end

require_relative '../../test_init'

context "Settings" do
  context "Reverse Backtraces" do
    Test::Fixtures::Settings::Setting::Boolean.(
      setting: :reverse_backtraces,
      default_value: false,
      env_var: 'TEST_BENCH_REVERSE_BACKTRACES'
    )
  end
end

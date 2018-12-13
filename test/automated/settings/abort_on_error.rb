require_relative '../../test_init'

context "Settings" do
  context "Abort on Error" do
    Test::Fixtures::Settings::Setting::Boolean.(
      setting: :abort_on_error,
      default_value: false,
      env_var: 'TEST_BENCH_ABORT_ON_ERROR'
    )
  end
end

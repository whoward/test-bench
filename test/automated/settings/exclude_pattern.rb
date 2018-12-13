require_relative '../../test_init'

context "Settings" do
  context "Exclude Pattern" do
    Test::Fixtures::Settings::Setting.(
      setting: :exclude_pattern,
      default_value: Controls::ExcludePattern::Default.example,
      setter_value: Controls::ExcludePattern.example,
      env_var: 'TEST_BENCH_EXCLUDE_PATTERN'
    ) do |test|
      test.environment_variable(
        Controls::ExcludePattern.text,
        Controls::ExcludePattern.example
      )

      test.invalid_environment_variable(Controls::ExcludePattern::Anomaly.text)
    end
  end
end

require_relative '../../test_init'

context "Settings" do
  context "Backtrace Filter" do
    Test::Fixtures::Settings::Setting.(
      setting: :backtrace_filter,
      default_value: Controls::BacktraceFilter::Default.example,
      setter_value: Controls::BacktraceFilter.example,
      env_var: 'TEST_BENCH_BACKTRACE_FILTER'
    ) do |test|
      test.environment_variable(
        Controls::BacktraceFilter.text,
        Controls::BacktraceFilter.example
      )

      test.invalid_environment_variable(Controls::BacktraceFilter::Anomaly.text)
    end
  end
end

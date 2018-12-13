require_relative '../../test_init'

context "Settings" do
  context "Color" do
    Test::Fixtures::Settings::Setting.(
      setting: :color,
      default_value: TestBench::Settings::Color.detect,
      setter_value: TestBench::Settings::Color.enabled,
      env_var: 'TEST_BENCH_COLOR'
    ) do |test|
      Controls::Environment::Value::Color::Enabled.list.each do |value|
        test.environment_variable(value, TestBench::Settings::Color.enabled)
      end

      Controls::Environment::Value::Color::Disabled.list.each do |value|
        test.environment_variable(value, TestBench::Settings::Color.disabled)
      end

      Controls::Environment::Value::Color::Detect.list.each do |value|
        test.environment_variable(value, TestBench::Settings::Color.detect)
      end

      invalid_value = Controls::Environment::Value::Color::Anomaly.example
      test.invalid_environment_variable(invalid_value)
    end
  end
end

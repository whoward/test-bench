module Test
  module Fixtures
    module Settings
      class Setting
        class Boolean
          include Test::Fixture

          def self.call(**args)
            instance = new
            instance.(**args)
          end

          def call(setting:, default_value:, env_var:)
            setter_value = !default_value

            Setting.(setting: setting, default_value: default_value, setter_value: setter_value, env_var: env_var) do |test|
              Controls::Environment::Value::Boolean::True.list.each do |value|
                test.environment_variable(value, true)
              end

              Controls::Environment::Value::Boolean::False.list.each do |value|
                test.environment_variable(value, false)
              end

              invalid_value = Controls::Environment::Value::Boolean::Anomaly.example
              test.invalid_environment_variable(invalid_value)
            end
          end
        end
      end
    end
  end
end

module Test
  module Fixtures
    module Settings
      class Setting
        class Fixture
          include Test::Fixture

          attr_reader :setting
          attr_reader :env_var

          def initialize(setting, env_var)
            @setting = setting
            @env_var = env_var
          end

          def environment_variable(value, control_value)
            context "Value: #{value.inspect}" do
              env = { env_var => value }

              settings = TestBench::Settings.build(env)

              get_value = settings.public_send(setting)

              test "Setting is set to #{control_value.inspect}" do
                assert(get_value == control_value)
              end
            end
          end

          def invalid_environment_variable(value)
            context "Invalid Value: #{value.inspect}" do
              env = { env_var => value }

              begin
                TestBench::Settings.build(env)
              rescue TestBench::Settings::Error => error
              end

              test "Raises error" do
                refute(error.nil?)
              end
            end
          end
        end
      end
    end
  end
end

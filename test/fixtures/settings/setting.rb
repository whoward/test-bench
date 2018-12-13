module Test
  module Fixtures
    module Settings
      class Setting
        include Test::Fixture

        def self.call(**args, &block)
          instance = new
          instance.(**args, &block)
        end

        def call(setting:, default_value:, setter_value:, env_var:, env_var_values: nil, &block)
          env_var_values ||= {}

          context "Value is Overridden" do
            env = {}

            settings = TestBench::Settings.build(env)

            settings.public_send("#{setting}=", setter_value)

            value = settings.public_send(setting)

            test "Setting is set to given value" do
              assert(value == setter_value)
            end
          end

          context "Default Value" do
            context "Environment Variable Not Set" do
              env = {}

              settings = TestBench::Settings.build(env)

              value = settings.public_send(setting)

              test "Setting is set to #{default_value.inspect}" do
                assert(settings.public_send(setting) == default_value)
              end
            end

            unless block.nil?
              context "Environment Variable Is Set (#{env_var})" do
                fixture = Fixture.new(setting, env_var)

                block.(fixture)
              end
            end
          end
        end
      end
    end
  end
end

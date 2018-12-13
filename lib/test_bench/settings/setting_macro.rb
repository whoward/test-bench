module TestBench
  class Settings
    module SettingMacro
      Error = Class.new(RuntimeError)

      def self.included(cls)
        cls.class_exec do
          extend SettingMacro
        end
      end

      def self.assure_setting(setting_name)
        valid_setting_names = Settings.setting_names

        unless valid_setting_names.include?(setting_name)
          raise Error, "Invalid setting (Setting: #{setting_name.inspect}, Valid Setting Names: #{valid_setting_names.map(&:inspect).join(', ')})"
        end
      end

      def setting_macro(setting_name)
        SettingMacro.assure_setting(setting_name)

        if instance_methods.include?(setting_name)
          raise Error, "Setting already registered (Setting: #{setting_name.inspect}, Receiver: #{self.name || '(anonymous)'})"
        end

        instance_variable = "@#{setting_name}"

        getter = setting_name
        define_method(getter) do
          instance_variable_get(instance_variable)
        end

        setter = "#{setting_name}="
        define_method(setter) do |value|
          instance_variable_set(instance_variable, value)
        end
      end
      alias_method :setting, :setting_macro
    end
  end
end

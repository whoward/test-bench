module TestBench
  class Telemetry
    module Handler
      def self.included(cls)
        cls.class_exec do
          include Settings::SettingMacro

          include Comment::Telemetry
          include Assert::Telemetry
          include Test::Telemetry
          include Context::Telemetry

          extend Build
          extend HandleMacro
        end
      end

      def configure
      end

      def handle(record)
        method_name = self.class.handler_method(record)

        if respond_to?(method_name)
          __send__(method_name, record)
        end
      end
      alias_method :send, :handle

      module HandleMacro
        def handle_macro(record_class, &block)
          method_name = handler_method(record_class)

          define_method(method_name, &block)
        end
        alias_method :handle, :handle_macro

        def handler_method(record_or_record_class)
          signal = record_or_record_class.signal

          "handle_#{signal}"
        end
      end

      module Build
        def build(settings=nil)
          settings ||= Settings.instance

          instance = new
          settings.set(instance)
          instance.configure
          instance
        end
      end
    end
  end
end

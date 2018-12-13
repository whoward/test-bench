module TestBench
  module Controls
    module Settings
      def self.example(**data)
        TestBench::Settings.new(data)
      end

      module Name
        def self.example
          :abort_on_error
        end

        def self.alternate
          :color
        end

        module Anomaly
          def self.example
            :not_a_setting
          end
        end
      end

      module Receiver
        def self.example(&define_block)
          cls = self.example_class(&define_block)
          cls.new
        end

        def self.example_class(&define_block)
          define_block ||= proc do
            setting Name.example
            setting Name.alternate
          end

          Class.new do
            include TestBench::Settings::SettingMacro

            class_exec(&define_block)
          end
        end

        Example = self.example_class
      end
    end
  end
end

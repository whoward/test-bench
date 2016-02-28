module TestBench
  class Settings
    module Registry
      extend self

      def registry
        @registry ||= TestBench::Registry.build do
          Settings.build
        end
      end

      def get binding
        registry.get binding
      end
    end
  end
end

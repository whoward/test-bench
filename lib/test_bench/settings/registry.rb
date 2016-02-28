module TestBench
  class Settings
    class Registry < TestBench::Registry
      def self.build
        new Settings
      end

      def self.instance
        @instance ||= build
      end

      def self.get binding
        instance.get binding
      end
    end
  end
end

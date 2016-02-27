module TestBench
  class Settings
    module Registry
      def self.instance
        @instance ||= TestBench::Registry.new Settings
      end

      def self.get binding
        instance.get binding
      end
    end
  end
end

module TestBench
  class Telemetry
    class Registry < TestBench::Registry
      def key binding
        "#{super}-#{Process.pid}"
      end

      def self.build
        new Telemetry
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

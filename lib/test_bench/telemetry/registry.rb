module TestBench
  class Telemetry
    class Registry
      def key binding
        "#{binding.receiver.object_id}-#{Process.pid}"
      end

      def get binding
        key = self.key binding
        table[key]
      end

      def table
        @table ||= Hash.new do |hash, key|
          hash[key] = Telemetry.build
        end
      end

      def self.instance
        @instance ||= new
      end

      def self.get binding
        instance.get binding
      end
    end
  end
end

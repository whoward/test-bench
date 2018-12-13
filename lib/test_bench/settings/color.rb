module TestBench
  class Settings
    module Color
      def self.enabled
        :enabled
      end

      def self.disabled
        :disabled
      end

      def self.detect
        :detect
      end
    end
  end
end

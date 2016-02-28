module TestBench
  class Settings
    module Defaults
      def self.color
        nil
      end
      
      def self.exclude_pattern
        "_init\\.rb$"
      end

      def self.fail_fast
        false
      end
    end
  end
end

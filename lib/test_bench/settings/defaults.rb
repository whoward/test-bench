module TestBench
  class Settings
    module Defaults
      def self.child_count
        1
      end
      
      def self.exclude_pattern
        "_init\\.rb$"
      end

      def self.fail_fast
        false
      end

      def self.internal_log_level
        'fatal'
      end
    end
  end
end

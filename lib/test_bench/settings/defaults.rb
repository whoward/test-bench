module TestBench
  class Settings
    module Defaults
      def self.color
        nil
      end
      
      def self.exclude_pattern
        "_init\\.rb$"
      end

      def self.abort_on_error
        false
      end
    end
  end
end

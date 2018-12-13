module TestBench
  module Controls
    module ExcludePattern
      def self.example
        Regexp.new(text)
      end

      def self.text
        '/_[[:alnum:]_]*\.rb$'
      end

      module Default
        def self.example
          TestBench::Settings::Data::Defaults.exclude_pattern
        end
      end

      module None
        def self.example
          Default.example
        end
      end

      module Anomaly
        def self.text
          '['
        end
      end
    end
  end
end

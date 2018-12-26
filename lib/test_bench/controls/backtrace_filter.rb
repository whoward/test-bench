module TestBench
  module Controls
    module BacktraceFilter
      def self.example
        Regexp.new(text)
      end

      def self.text
        'filter_match'
      end

      module Default
        def self.example
          TestBench::Settings::Data::Defaults.backtrace_filter
        end
      end

      module None
        def self.example
          %r{\z\A}
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

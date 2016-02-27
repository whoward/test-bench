module TestBench
  module Controls
    module Error
      def self.example
        AssertionFailed.example
      end

      def self.detail indent: nil, **colors
        indent ||= 0

        error = example
        indent = '  ' * indent

        <<-TEXT
#{indent}#{Output::Palette.apply "#{file}:#{line}:in `#{method_name}': Assertion failed (#{error.class})", **colors}
#{indent}#{Output::Palette.apply "        from #{file}:#{line + 1}:in `#{method_name}'", **colors}
#{indent}#{Output::Palette.apply "        from #{file}:#{line + 2}:in `#{method_name}'", **colors}
        TEXT
      end

      def self.file
        Path.example
      end

      def self.line
        1
      end

      def self.method_name
        'some_method'
      end

      def self.backtrace_locations
        [
          BacktraceLocation.new(file, line, method_name),
          BacktraceLocation.new(file, line + 1, method_name),
          BacktraceLocation.new(file, line + 2, method_name),
        ]
      end

      class BacktraceLocation
        attr_reader :label
        attr_reader :lineno
        attr_reader :path

        def initialize path, lineno, label
          @label = label
          @lineno = lineno
          @path = path
        end

        def to_s
          "#{path}:#{lineno}:in `#{label}'"
        end
      end

      module AssertionFailed
        def self.example
          backtrace_locations = Error.backtrace_locations

          Assert::Failed.build backtrace_locations
        end
      end
    end
  end
end

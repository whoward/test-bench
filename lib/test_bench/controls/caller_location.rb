module TestBench
  module Controls
    module CallerLocation
      def self.example(path: nil, line_number: nil)
        path ||= self.path
        line_number ||= self.line_number

        Example.new(path, line_number)
      end

      def self.path
        __FILE__
      end

      def self.line_number
        11
      end

      Example = Struct.new(:path, :lineno)
    end
  end
end

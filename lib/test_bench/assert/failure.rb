module TestBench
  module Assert
    class Failure < RuntimeError
      def self.message
        'Assertion failed'
      end
    end
  end
end

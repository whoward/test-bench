module TestBench
  module Controls
    module Time
      def self.example
        ::Time.new(
          year,
          month,
          day,
          hour,
          minute,
          second,
          utc_offset
        )
      end

      def self.year
        2000
      end

      def self.month
        1
      end

      def self.day
        1
      end

      def self.hour
        11
      end

      def self.minute
        11
      end

      def self.second
        one_repeating = Rational(1, 9)

        11 + one_repeating
      end

      def self.utc_offset
        0
      end
    end
  end
end

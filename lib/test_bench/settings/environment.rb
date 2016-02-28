module TestBench
  class Settings
    class Environment
      attr_reader :settings
      attr_writer :env

      def initialize settings
        @settings = settings
      end

      def self.build settings, env=nil
        env ||= ENV

        instance = new settings
        instance.env = env
        instance
      end

      def self.call *arguments
        instance = build *arguments
        instance.()
      end

      def activated? value
        if affirmative_pattern.match value
          true
        elsif value.nil? or negative_pattern.match value
          false
        else
          raise ArgumentError, %{Invalid boolean value #{value.inspect}; values that are toggled can be set via "on" or "off", "yes" or "no", "y" or "n", or "0" or "1".}
        end
      end

      def affirmative_pattern
        @@affirmative_pattern ||= %r{\A(?:on|yes|y|1)\z}i
      end

      def call
        fail_fast
        quiet
        verbose
      end

      def env
        @env ||= {}
      end

      def fail_fast
        if activated? env['TEST_BENCH_FAIL_FAST']
          settings.fail_fast = true
        end
      end

      def negative_pattern
        @@negative_pattern ||= %r{\A(?:off|no|n|0)\z}i
      end

      def quiet
        if activated? env['TEST_BENCH_QUIET']
          settings.lower_verbosity
          settings.lower_verbosity
        end
      end

      def verbose
        if activated? env['TEST_BENCH_VERBOSE']
          settings.raise_verbosity
          settings.raise_verbosity
        end
      end
    end
  end
end

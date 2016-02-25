module TestBench
  class Settings
    class Environment
      using NullObject::NullAttribute

      attr_writer :env

      null_attr :settings

      def self.build settings=nil, env=nil
        env ||= ENV

        instance = new
        instance.env = env

        if settings
          instance.settings = settings
        else
          Settings.configure instance
        end

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

      def bootstrap
        if activated? env['TEST_BENCH_BOOTSTRAP']
          settings.bootstrap = true
        end
      end

      def call
        bootstrap
        child_count
        fail_fast
        internal_log_level
      end

      def child_count
        if env.key? 'TEST_BENCH_CHILD_COUNT'
          settings.child_count = Integer(env['TEST_BENCH_CHILD_COUNT'])
        end
      end

      def env
        @env ||= {}
      end

      def fail_fast
        if activated? env['TEST_BENCH_FAIL_FAST']
          settings.fail_fast = true
        end
      end

      def internal_log_level
        if env.key? 'TEST_BENCH_INTERNAL_LOG_LEVEL'
          settings.internal_log_level = env['TEST_BENCH_INTERNAL_LOG_LEVEL']
        end
      end

      def negative_pattern
        @@negative_pattern ||= %r{\A(?:off|no|n|0)\z}i
      end
    end
  end
end

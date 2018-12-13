module TestBench
  class Settings
    module Data
      def self.get(env=nil)
        env ||= ::ENV

        environment = Environment.new(env)

        abort_on_error = coalesce(environment.abort_on_error, Defaults.abort_on_error)

        backtrace_filter = coalesce(environment.backtrace_filter, Defaults.backtrace_filter)

        color = coalesce(environment.color, Defaults.color)

        exclude_pattern = coalesce(environment.exclude_pattern, Defaults.exclude_pattern)

        reverse_backtraces = coalesce(environment.reverse_backtraces, Defaults.reverse_backtraces) 

        silent = coalesce(environment.silent, Defaults.silent)

        {
          :abort_on_error => abort_on_error,
          :backtrace_filter => backtrace_filter,
          :color => color,
          :exclude_pattern => exclude_pattern,
          :reverse_backtraces => reverse_backtraces,
          :silent => silent
        }
      end

      def self.coalesce(*values)
        values.find do |value|
          !value.nil?
        end
      end

      module Defaults
        def self.abort_on_error
          false
        end

        def self.backtrace_filter
          %r{lib/test_bench/}
        end

        def self.color
          Color.detect
        end

        def self.exclude_pattern
          %r{\z\A}
        end

        def self.reverse_backtraces
          false
        end

        def self.silent
          false
        end
      end

      class Environment
        attr_reader :env

        def initialize(env)
          @env = env
        end

        def abort_on_error(env_var=nil)
          env_var ||= 'TEST_BENCH_ABORT_ON_ERROR'

          get(env_var, Parsers::Boolean)
        end

        def backtrace_filter(env_var=nil)
          env_var ||= 'TEST_BENCH_BACKTRACE_FILTER'

          get(env_var, Parsers::Pattern)
        end

        def color(env_var=nil)
          env_var ||= 'TEST_BENCH_COLOR'

          get(env_var, Parsers::Color)
        end

        def exclude_pattern(env_var=nil)
          env_var ||= 'TEST_BENCH_EXCLUDE_PATTERN'

          get(env_var, Parsers::Pattern)
        end

        def reverse_backtraces(env_var=nil)
          env_var ||= 'TEST_BENCH_REVERSE_BACKTRACES'

          get(env_var, Parsers::Boolean)
        end

        def silent(env_var=nil)
          env_var ||= 'TEST_BENCH_SILENT'

          get(env_var, Parsers::Boolean)
        end

        def get(env_var, parse)
          text_value = env[env_var] or return nil

          value = parse.(text_value)

          if value.nil?
            raise Error, "Environment variable set to invalid value (Variable: #{env_var}, Value: #{text_value})"
          end

          value
        end

        module Parsers
          module Boolean
            def self.call(text_value)
              case text_value
              when true_pattern
                true
              when false_pattern
                false
              else
                nil
              end
            end

            def self.true_pattern
              %r{\A(?:enabled|on|true|t|yes|y|1)\z}i
            end

            def self.false_pattern
              %r{\A(?:disabled|false|f|no|n|off|0)\z}i
            end
          end

          module Color
            def self.call(text_value)
              case text_value
              when detect_pattern
                Settings::Color.detect
              when enabled_pattern
                Settings::Color.enabled
              when disabled_pattern
                Settings::Color.disabled
              else
                nil
              end
            end

            def self.detect_pattern
              %r{\A(?:auto|detect)\z}i
            end

            def self.enabled_pattern
              Boolean.true_pattern
            end

            def self.disabled_pattern
              Boolean.false_pattern
            end
          end

          module Pattern
            def self.call(text_value)
              ::Regexp.new(text_value)

            rescue RegexpError
              return nil
            end
          end
        end
      end
    end
  end
end

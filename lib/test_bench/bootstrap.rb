module TestBench
  module Bootstrap
    def self.activate(receiver=nil)
      receiver ||= TOPLEVEL_BINDING.receiver

      receiver.extend(Fixture)
    end

    module Assert
      ArgumentOmitted = Object.new

      Failure = Class.new(RuntimeError)

      def self.call(subject=nil, assertions_module=nil, negate: nil, caller_location: nil, &block)
        negate ||= false
        caller_location ||= caller[0]

        if subject == ArgumentOmitted
          if block.nil?
            raise ArgumentError, "Neither positional nor block argument given"
          end
        end

        if block
          subject = nil if subject == ArgumentOmitted

          assertions_module ||= AssertionsModule.get(subject)

          subject.extend(Fixture)
          subject.extend(assertions_module)

          begin
            subject.instance_exec(subject, &block)
            passed = true

          rescue Failure
            passed = false
          end
        else
          passed = subject
        end

        passed = !passed if negate

        return if passed

        failure = Failure.new("Assertion failed")
        failure.set_backtrace([caller_location])
        raise failure
      end

      module AssertionsModule
        def self.get(subject, module_name: nil)
          module_name ||= :Assertions

          if subject.is_a?(Module)
            namespace = subject
          else
            namespace = subject.class
          end

          unless namespace.const_defined?(module_name)
            fail "Could not resolve Assertions module (Namespace: #{namespace}, Subject: #{subject.inspect})"
          end

          namespace.const_get(module_name)
        end
      end
    end

    module Fixture
      extend self

      def assert(subject=Assert::ArgumentOmitted, assertions_module=nil, &block)
        caller_location = caller[0]

        Assert.(subject, assertions_module, negate: false, caller_location: caller_location, &block)
      end

      def comment(prose)
        prose = prose.inspect unless prose.is_a?(String)

        Indent.(prose)
      end

      def context(prose=nil, abort_on_error: nil, &block)
        abort_on_error ||= Settings.abort_on_error
        block ||= proc { }

        if prose.nil?
          block.()
          return
        end

        Indent.("\e[32m#{prose}\e[0m") do |indentation|
          begin
            block.()

          rescue => error
            RenderError.(error)

            if abort_on_error
              exit 1
            end

          ensure
            Indent.('') if indentation == 1
          end
        end
      end

      def refute(subject=Assert::ArgumentOmitted, assertions_module=nil, &block)
        caller_location = caller[0]

        Assert.(subject, assertions_module, negate: true, caller_location: caller_location, &block)
      end

      def test(prose=nil, abort_on_error: nil, &block)
        prose ||= 'Test'
        abort_on_error ||= Settings.abort_on_error
        block ||= proc { }

        begin
          block.()

        rescue => error
        end

        if error.nil?
          Indent.("\e[32m#{prose}\e[0m")
          true
        else
          Indent.("\e[1;31m#{prose}\e[0m") do
            RenderError.(error)
          end

          if abort_on_error
            exit 1
          end

          false
        end
      end

      module Indent
        extend self

        def indentation
          @indentation ||= 0
        end
        attr_writer :indentation

        def self.call(prose=nil, &block)
          unless prose.nil?
            puts "#{'  ' * indentation}#{prose}"
          end

          unless block.nil?
            self.indentation += 1

            begin
              block.(indentation)

            ensure
              self.indentation -= 1
            end
          end
        end
      end

      module RenderError
        def self.call(error, current_directory=nil)
          current_directory ||= Dir.pwd

          full_message = []

          error.full_message.each_line do |line|
            if line.include?(__FILE__)
              unless full_message.last.match?(/\*filtered\*/)
                line.gsub!(/\A(?<indentation>[[:blank:]]*(?:[[:digit:]]+:[[:blank:]]+)?).*\Z/) do
                  match = Regexp.last_match

                  indentation = match[:indentation]

                  indentation.gsub!(/[[:digit:]]+/) do |index|
                    index.tr!('0-9', ' ')
                    index[-1] = '?'
                    index
                  end

                  "#{indentation}*filtered*"
                end

                full_message << line
              end
            else
              line.gsub!("#{current_directory}/", './')

              full_message << line
            end
          end

          full_message.each do |line|
            line.chomp!

            Indent.("\e[31m#{line}\e[0m")
          end
        end
      end
    end

    module Run
      def self.call(*paths, abort_on_error: nil, exclude_pattern: nil)
        abort_on_error ||= Settings.abort_on_error
        exclude_pattern ||= Settings.exclude_pattern

        files = paths.flat_map do |path|
          get_files(path)
        end

        passed = true

        files.each do |file|
          next if exclude_pattern.match?(file)

          unless execute(file)
            passed = false

            break if abort_on_error
          end
        end

        if abort_on_error
          passed
        else
          warn "TestBench::Bootstrap cannot determine if run passed when TEST_BENCH_ABORT_ON_ERROR is disabled; exiting with nonzero status"
          exit 1
        end
      end

      def self.get_files(path)
        if File.directory?(path)
          file_pattern = File.join(path, '**', '*.rb')

          Dir[file_pattern].to_a
        elsif File.exist?(path)
          [path]
        else
          warn "Specified path not found: #{path.inspect}"

          []
        end
      end

      def self.execute(file)
        puts "Executing #{file}"

        load(file)

        true

      rescue StandardError => error
        warn error.full_message

        return false

      rescue SystemExit => system_exit
        return system_exit.success?
      end
    end

    module Settings
      def self.abort_on_error
        boolean('TEST_BENCH_ABORT_ON_ERROR', false)
      end

      def self.exclude_pattern
        pattern('TEST_BENCH_EXCLUDE_PATTERN', '(?:_.*|automated_init).rb')
      end

      def self.boolean(env_var, default_value)
        env_value = ::ENV[env_var]
        env_value = nil if env_value == ''

        return default_value if env_value.nil?

        if %r{\A(?:enabled|on|true|t|yes|y|1)\z}i.match?(env_value)
          true
        elsif %r{\A(?:disabled|false|f|no|n|off|0)\z}i.match?(env_value)
          false
        else
          fail "Non-boolean value for #{env_var.inspect}"
        end
      end

      def self.pattern(env_var, default_value)
        env_value = ::ENV[env_var]
        env_value = nil if env_value == ''

        pattern = env_value || default_value

        Regexp.new(pattern)
      end
    end
  end
end

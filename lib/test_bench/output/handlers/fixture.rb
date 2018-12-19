module TestBench
  module Output
    module Handlers
      class Fixture
        include Telemetry::Handler

        include Device::Dependency
        include Format::Dependency
        include RenderError::Dependency

        attr_writer :indentation
        def indentation
          @indentation ||= 0
        end

        def configure
          Device.configure(self)
          Format.configure(self)
          RenderError.configure(self)
        end

        handle Commented do |commented|
          prose = commented.prose

          output = format.(prose)

          puts(output)
        end

        handle ContextEntered do |context_entered|
          prose = context_entered.prose

          return if prose.nil?

          output = format.(prose, fg: :green)

          puts(output)

          self.indentation += 1
        end

        handle ContextExited do |context_exited|
          prose = context_exited.prose

          return if prose.nil?

          self.indentation -= 1

          puts if indentation.zero?
        end

        handle TestPassed do |test_passed|
          prose = test_passed.prose

          prose ||= 'Test'

          output = format.(prose, fg: :green)

          puts(output)
        end

        handle TestFailed do |test_failed|
          prose = test_failed.prose

          prose ||= 'Test'

          output = format.(prose, fg: :red)

          puts(output)
        end

        handle TestSkipped do |test_skipped|
          prose = test_skipped.prose

          prose ||= 'Test'

          output = format.(prose, fg: :yellow)

          puts(output)
        end

        handle ErrorRaised do |error_raised|
          error = error_raised.error

          backtrace_text = render_error.(error)

          indent(backtrace_text)
        end

        def puts(text=nil)
          indentation = '  ' * self.indentation

          device.write(indentation)

          device.puts(text)
        end

        def indent(text)
          text.each_line do |line|
            puts(line.chomp)
          end
        end
      end
    end
  end
end

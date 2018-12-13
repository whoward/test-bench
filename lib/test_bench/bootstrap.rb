module TestBench
  module Bootstrap
    def self.activate(receiver=nil)
      receiver ||= TOPLEVEL_BINDING.receiver

      receiver.extend(Fixture)
    end

    module Fixture
      def context(prose=nil, &block)
        indent(prose, ansi_color: 0x32) do
          block.() unless block.nil?
        end
      end

      def test(prose=nil, &block)
        prose ||= 'Test'

        context(prose, &block)
      end

      def assert(value, caller_location: nil)
        caller_location ||= caller[0]

        unless value
          print("Assertion failed: #{caller_location}", ansi_color: 0x31, device: $stderr)
          exit 1
        end
      end

      def refute(value, caller_location: nil)
        caller_location ||= caller[0]

        assert(!value, caller_location: caller_location)
      end

      def comment(prose)
        print(prose)
      end

      def indent_level
        @@indent_level ||= 0
      end

      def indent_level=(value)
        @@indent_level = value
      end

      def indent(text=nil, **args, &block)
        unless text.nil?
          print(text, **args, &block)
        end

        self.indent_level += 1

        begin
          block.()
        ensure
          self.indent_level -=1
        end
      end

      def print(text, ansi_color: nil, device: nil, &block)
        device ||= $stdout

        unless ansi_color.nil?
          text = "\e[0;#{ansi_color.to_s(16)}m#{text}\e[0m"
        end

        device.puts "#{' ' * indent_level}#{text}"
      end
    end

    module Run
      def self.call(*file_patterns, exclude_pattern: nil)
        exclude_pattern ||= %r{\z.}

        file_patterns.each do |file_pattern|
          if File.directory?(file_pattern)
            file_pattern = File.join(file_pattern, '**/*.rb')
          end

          files = Dir[file_pattern].reject do |file|
            File.basename(file).match?(exclude_pattern)
          end

          files.sort.each do |file|
            puts "Running #{file}"

            begin
              load file
            ensure
              puts
            end
          end
        end
      end
    end

    module CLI
      def self.call(argv=nil)
        argv ||= ::ARGV

        if argv.empty?
          file_patterns = 'test/automated/**/*.rb'
        else
          file_patterns = argv
        end

        Run.(*file_patterns)
      end
    end
  end
end

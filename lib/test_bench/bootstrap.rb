module TestBench
  module Bootstrap
    def assert subject, &block
      block ||= ->*{ self }

      namespace = if Module === subject then subject else subject.class end
      if namespace.const_defined? :Assertions
        assertions_module = namespace.const_get :Assertions
        subject.extend assertions_module
      end

      unless subject.instance_exec subject, &block
        frame = caller_locations[0]
        $stderr.puts "\e[1;37;41mAssertion failed (File: #{frame.path.inspect}, Line: #{frame.lineno})"
        fail
      end
    end

    def context message, &block
      format_method = if block then :step else :skip end
      message = Bootstrap.public_send format_method, message
      puts message

      Bootstrap.indent

      begin
        block.() if block
      ensure
        Bootstrap.deindent
      end
    end

    def test message=nil, &block
      message ||= "Test"
      context message, &block
    end

    module Runner
      def self.call paths
        files = paths.flat_map do |path|
          if Dir.exist? path
            Dir["#{path}/**/*.rb"]
          else
            [path]
          end
        end

        settings = Settings.toplevel
        exclude_pattern = Regexp.new settings.exclude_pattern

        files.each do |file|
          next if exclude_pattern.match file

          $stderr.puts "Running #{file}"
          load file
          $stderr.puts 
        end
      end
    end

    class << self
      attr_accessor :indentation

      def deindent
        self.indentation -= 1
      end

      def indent
        self.indentation += 1
      end

      def skip message
        "#{'  ' * indentation}\e[0;33m#{message}\e[0m"
      end

      def step message
        "#{'  ' * indentation}\e[0;32m#{message}\e[0m"
      end
    end

    self.indentation = 0
  end
end

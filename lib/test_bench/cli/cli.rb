module TestBench
  class CLI
    using NullObject::NullAttribute

    include InternalLogging

    attr_reader :argv

    null_attr :settings

    def initialize argv
      @argv = argv
    end

    def self.call argv=nil
      argv ||= ARGV

      instance = new argv
      Settings.configure instance
      instance.()
    end

    def call
      logger.trace "Starting CLI (Arguments: #{argv.inspect})"

      option_parser.parse! argv

      logger.data do
        settings_text = JSON.pretty_generate settings.to_h
        "Settings:\n#{settings_text}"
      end

      paths = argv
      paths << 'tests' if paths.empty?

      TestBench.runner.(paths) or exit 1
    end

    def help
      puts option_parser.help
      puts
      puts <<-TEXT
If no paths are specified, #{program_name} runs all files in ./tests. Execution
can also be controlled additionally via the following environment variables.
Values that are toggled can be set via "on" or "off", "yes" or "no", "y" or "n",
or "0" or "1".

    TEST_BENCH_BOOTSTRAP             When active, uses a minimal implementation
                                     of "assert", "context", and "activate" that
                                     will work even when test-bench itself is
                                     under test.
    TEST_BENCH_CHILD_COUNT           Same as --child-count
    TEST_BENCH_FAIL_FAST             Same as --fail-fast
    TEST_BENCH_INTERNAL_LOG_LEVEL    Activates and sets the log level for the
                                     internal logging system. Valid values are
                                     "data", "trace", "debug", "info", "warn",
                                     "error" and "fatal". Useful for debugging
                                     test-bench itself.
      TEXT
    end

    def option_parser
      @option_parser ||= OptionParser.new do |parser|
        parser.on '-f', '--fail-fast', "Exit immediately after any test script fails" do
          settings.fail_fast = true
        end

        parser.on '-h', '--help', "Print this help message and exit successfully" do
          help
          exit 0
        end

        parser.on '-n', '--child-count NUM', "Maximum number of processes to run in parallel" do |number|
          settings.child_count = Integer(number)
        end

        parser.on '-p', '--preload FILE', "Preload FILE before loading test scripts" do |file|
          file = File.expand_path file

          current_path = Pathname.new __dir__
          file_path = Pathname.new file

          relative_path = file_path.relative_path_from current_path
          require_relative relative_path
        end

        parser.on '-q', '--quiet', "Lower verbosity level" do
          settings.lower_verbosity
        end

        parser.on '-v', '--verbose', "Raise verbosity level" do
          settings.raise_verbosity
        end

        parser.on '-V', '--version', "Print version and exit successfully" do
          puts "test-bench (#{parser.program_name}) version #{version}"
          exit 0
        end

        parser.on '-x', '--exclude PATTERN', %{Filter out files matching PATTERN (Default is "_init$")} do |pattern|
          settings.exclude_pattern = pattern
        end
      end
    end

    def program_name
      File.basename $PROGRAM_NAME
    end
  end
end

module TestBench
  class CLI
    using NullObject::NullAttribute

    attr_reader :argv

    null_attr :settings

    def initialize argv
      @argv = argv
    end

    def self.call argv=nil
      argv ||= ARGV

      instance = new argv
      instance.settings = Settings.toplevel
      instance.()
    end

    def call
      option_parser.parse! argv

      paths = argv
      paths << 'tests' if paths.empty?

      current_directory = File.expand_path Dir.pwd

      TestBench::Runner.(paths, current_directory) or exit 1
    end

    def help
      puts option_parser.help
      puts
      puts <<-TEXT
If no paths are specified, #{program_name} runs all files in ./tests. The
following environment variables can also control execution:

        TEST_BENCH_CHILD_COUNT     Same as -n or --child-count
        TEST_BENCH_FAIL_FAST       Same as -f or --fail-fast
        TEST_BENCH_QUIET           Same as -q or --quiet
        TEST_BENCH_VERBOSE         Same as -v or --verbose
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

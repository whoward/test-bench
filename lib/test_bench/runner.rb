module TestBench
  class Runner
    attr_writer :executor
    attr_writer :expand_path
    attr_reader :paths
    attr_writer :telemetry

    def initialize paths
      @paths = paths
    end

    def self.build paths, root_directory, exclude_pattern: nil
      instance = new paths
      instance.executor = Executor.build
      instance.expand_path = ExpandPath.build root_directory, exclude_pattern
      instance.telemetry = Telemetry::Registry.get TOPLEVEL_BINDING
      instance
    end

    def self.call paths, root_directory=nil, exclude_pattern: nil
      paths = Array paths
      root_directory ||= File.dirname caller_locations[0].path

      instance = build paths, root_directory, :exclude_pattern => exclude_pattern
      instance.()
    end

    def call
      telemetry.run_started

      files = gather_files
      execute files

    rescue SystemExit => system_exit

    ensure
      telemetry.run_finished

      raise system_exit if system_exit

      return telemetry.passed?
    end

    def gather_files
      paths.flat_map do |path|
        Array expand_path.(path)
      end
    end

    def execute files
      executor.(files)
    end

    def executor
      @executor ||= Executor.build
    end

    def expand_path
      @expand_path ||= Proc.new do [] end
    end

    def telemetry
      @telemetry ||= Telemetry.build
    end
  end
end

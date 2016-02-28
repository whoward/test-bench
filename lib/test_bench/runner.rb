module TestBench
  class Runner
    using NullObject::NullAttribute

    attr_reader :paths
    attr_writer :telemetry

    null_attr :executor
    null_attr :expand_path
    null_attr :telemetry

    def initialize paths
      @paths = paths
    end

    def self.build paths, root_directory
      instance = new paths
      instance.executor = Executor.build
      instance.expand_path = ExpandPath.build root_directory
      instance.telemetry = Telemetry.toplevel
      instance
    end

    def self.call paths, root_directory=nil
      root_directory ||= File.dirname caller_locations[0].path
      instance = build paths, root_directory
      instance.()
    end

    def call
      telemetry.run_started

      files = gather_files
      execute files

      telemetry.run_finished

      telemetry.passed?
    end

    def gather_files
      paths.flat_map do |path|
        Array expand_path.(path)
      end
    end

    def execute files
      executor.(files)
    end
  end
end

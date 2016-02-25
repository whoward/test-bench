module TestBench
  class Runner
    using NullObject::NullAttribute

    include InternalLogging

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
      Telemetry.configure instance
      ExpandPath.configure instance, root_directory
      instance
    end

    def self.call paths
      root_directory = File.dirname caller_locations[0].path
      instance = build paths, root_directory
      instance.()
    end

    def call
      telemetry.started
      logger.trace "Running (Start: #{telemetry.start_time.inspect})"

      gather_files
      execute

      telemetry.stopped

      logger.debug "Ran (Start: #{telemetry.start_time.inspect}, Stop: #{telemetry.stop_time.inspect}, Passed: #{telemetry.passed?})"
      telemetry.passed?
    end

    def gather_files
      logger.trace "Gathering files (Paths: #{paths.size})"

      files = paths.flat_map do |path|
        Array expand_path.(path)
      end

      executor.add *files

      logger.debug "Gathered files (Paths: #{paths.size}, Files: #{files.size})"

      files
    end

    def execute
      logger.trace "Executing (Executor: #{executor.class.inspect})"

      executor.(telemetry)

      logger.debug "Executed (Executor: #{executor.class.inspect})"
    end
  end
end

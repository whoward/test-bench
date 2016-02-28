module TestBench
  class Executor
    attr_reader :binding
    attr_reader :child_count
    attr_reader :file_module

    def initialize binding, child_count, file_module
      @binding = binding
      @child_count = child_count
      @file_module = file_module
    end

    def self.build
      binding = TOPLEVEL_BINDING
      child_count = Settings.toplevel.child_count

      new binding, child_count, File
    end

    def call files, &block
      files.each do |file|
        execute file
        block.(file) if block_given?
      end

      telemetry.passed?
    end

    def execute file
      test_script = file_module.read file
      test_script = "context do; #{test_script}; end"

      telemetry.file_started file

      begin
        binding.eval test_script, file
      ensure
        telemetry.file_finished file
        telemetry.stopped
      end
    end

    def settings
      Settings::Registry.get binding
    end

    def telemetry
      Telemetry::Registry.get binding
    end
  end
end

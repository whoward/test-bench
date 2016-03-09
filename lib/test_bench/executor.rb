module TestBench
  class Executor
    attr_reader :binding
    attr_reader :file_module

    def initialize binding, file_module
      @binding = binding
      @file_module = file_module
    end

    def self.build
      binding = TOPLEVEL_BINDING

      new binding, File
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

      telemetry.file_started file

      begin
        binding.receiver.context :suppress_exit => true do
          binding.eval test_script, file
        end

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

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
        wait child_count - 1

        break if settings.fail_fast and telemetry.failed?

        pid, telemetry_consumer = spawn_process do
          child_process file
        end

        process_map[pid] = telemetry_consumer

        block.(file) if block_given?
      end

      wait 0

      telemetry.passed?
    end

    def child_process file
      test_script = file_module.read file
      test_script = "context do; #{test_script}; end"

      child_telemetry = Telemetry.build
      child_telemetry.output = telemetry.output
      Telemetry::Registry.set binding, child_telemetry

      telemetry.file_started file

      begin
        binding.eval test_script, file
      ensure
        telemetry.file_finished file
        telemetry.stopped
      end
    end

    def process_map
      @process_map ||= {}
    end

    def read_telemetry telemetry_consumer
      telemetry_data = telemetry_consumer.read
      telemetry_consumer.close

      telemetry = Telemetry.load telemetry_data
      self.telemetry << telemetry
    end

    def spawn_process &block
      telemetry_consumer, telemetry_producer = IO.pipe

      child_pid = fork do
        telemetry_consumer.close

        begin
          block.()
        ensure
          telemetry_data = Telemetry.dump telemetry

          telemetry_producer.write telemetry_data
          telemetry_producer.close
        end
      end

      telemetry_producer.close

      return child_pid, telemetry_consumer
    end

    def wait process_count
      while process_map.size > process_count
        pid = Process.wait

        io = process_map.delete pid
        read_telemetry io
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

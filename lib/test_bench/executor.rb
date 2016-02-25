module TestBench
  class Executor
    using NullObject::NullAttribute

    attr_reader :binding
    attr_reader :child_count
    attr_reader :file_module

    null_attr :telemetry

    def initialize binding, child_count, file_module
      @binding = binding
      @child_count = child_count
      @file_module = file_module
    end

    def call files, &block
      files.each do |file|
        wait child_count - 1

        pid, telemetry_consumer = spawn_process do |telemetry_producer|
          child_process telemetry_producer, file
        end

        process_map[pid] = telemetry_consumer

        block.(file) if block_given?
      end

      wait 0
    end

    def child_process telemetry_producer, file
      test_script = file_module.read file

      telemetry = Telemetry::Registry.get binding

      begin
        binding.eval test_script, file
      ensure
        telemetry.file_executed file
        telemetry.stopped
        telemetry_data = Telemetry.dump telemetry

        telemetry_producer.write telemetry_data
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
      telemetry_producer, telemetry_consumer = IO.pipe

      child_pid = fork do
        telemetry_producer.close

        begin
          block.(telemetry_consumer)
        ensure
          telemetry_consumer.close unless telemetry_consumer.closed?
        end
      end

      telemetry_consumer.close

      return child_pid, telemetry_producer
    end

    def wait process_count
      while process_map.size > process_count
        pid = Process.wait

        io = process_map.delete pid
        read_telemetry io
      end
    end
  end
end

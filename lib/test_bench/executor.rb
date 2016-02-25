module TestBench
  class Executor
    using NullObject::NullAttribute

    attr_reader :binding
    attr_reader :child_count
    attr_reader :file_module

    null_attr :telemetry

    def initialize binding, child_count, file_module
      @telemetry = telemetry
      @binding = binding
      @child_count = child_count
      @file_module = file_module
    end

    def call files, &block
      files.each do |file|
        wait child_count - 1

        pid, parent_io = spawn_process do |child_io|
          child_process child_io, file
        end

        processes[pid] = parent_io

        block.(file) if block_given?
      end

      wait 0
    end

    def child_process child_io, file
      test_script = file_module.read file
      telemetry = Telemetry.build

      begin
        binding.eval test_script, file
      ensure
        telemetry.file_executed file
        telemetry.stopped
        telemetry_data = Telemetry.dump telemetry

        child_io.write telemetry_data
        child_io.close
      end
    end

    def processes
      @processes ||= {}
    end

    def read_telemetry io
      telemetry_data = io.read
      io.close

      telemetry = Telemetry.load telemetry_data
      self.telemetry << telemetry
    end

    def spawn_process &block
      parent_read_io, child_write_io = IO.pipe

      child_pid = fork do
        parent_read_io.close

        begin
          block.(child_write_io)
        ensure
          child_write_io.close unless child_write_io.closed?
        end
      end

      child_write_io.close

      return child_pid, parent_read_io
    end

    def wait process_count
      while processes.size > process_count
        pid = ::Process.wait

        io = processes.delete pid
        read_telemetry io
      end
    end
  end
end

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

        process = Process.start do |io|
          child_process io, file
        end

        processes[process.pid] = process

        block.(file) if block_given?
      end

      wait 0
    end

    def child_process io, file
      test_script = file_module.read file
      telemetry = Telemetry.build

      begin
        binding.eval test_script, file
      ensure
        telemetry.file_executed file
        telemetry.stopped
        telemetry_data = Telemetry.dump telemetry
        io.write telemetry_data
      end
    end

    def processes
      @processes ||= {}
    end

    def wait process_count
      while processes.size > process_count
        pid = ::Process.wait

        process = processes.delete pid
        self.telemetry << process.read_telemetry
      end
    end

    Process = Struct.new :pid, :telemetry_io do
      def self.start &child_block
        parent_read_io, child_write_io = IO.pipe

        child_pid = fork do
          parent_read_io.close

          begin
            child_block.(child_write_io)
          ensure
            child_write_io.close unless child_write_io.closed?
          end
        end

        child_write_io.close

        new child_pid, parent_read_io
      end

      def read_telemetry
        telemetry_data = telemetry_io.read
        Telemetry.load telemetry_data
      end

      def stopped?
        ::Process.kill 0, pid
        false
      rescue Errno::ESRCH
        return true
      end
    end
  end
end

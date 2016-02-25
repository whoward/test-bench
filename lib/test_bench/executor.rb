module TestBench
  class Executor
    using NullObject::NullAttribute

    attr_reader :binding
    attr_reader :child_count
    attr_reader :file_module
    attr_writer :parallel_process_max

    null_attr :telemetry

    def initialize binding, child_count, file_module
      @telemetry = telemetry
      @binding = binding
      @child_count = child_count
      @file_module = file_module
    end

    def add *files
      self.files.concat files
    end

    def call
      files.each do |file|
        parent_read_io, child_write_io = IO.pipe

        while processes.size >= child_count
          processes.delete_if &:stopped?
          ::Process.wait
        end

        child_pid = fork do
          parent_read_io.close

          telemetry = Telemetry.build

          file_contents = file_module.read file

          begin
            binding.eval file_contents, file
          ensure
            telemetry.file_executed file
            telemetry.stopped
            telemetry_data = Telemetry.dump telemetry
            child_write_io.write telemetry_data
          end
        end

        child_write_io.close

        process = Process.new child_pid, parent_read_io
        process_started process
      end

      ::Process.waitall

      processes.each do |process|
        telemetry_data = process.telemetry_io.read
        process_telemetry = Telemetry.load telemetry_data

        telemetry << process_telemetry
      end
    end

    def files
      @files ||= []
    end

    def parallel_process_max
      @parallel_process_max ||= 0
    end

    def process_started process
      processes << process
      self.parallel_process_max = [processes.size, parallel_process_max].max
    end

    def processes
      @processes ||= []
    end

    Process = Struct.new :pid, :telemetry_io do
      def stopped?
        ::Process.kill 0, pid
        false
      rescue Errno::ESRCH
        return true
      end
    end

    module Assertions
      def parallel_process_max? count
        parallel_process_max == count
      end
    end
  end
end

module TestBench
  module Executor
    class Serial
      using NullObject::NullAttribute

      attr_reader :binding
      attr_reader :file_module

      null_attr :telemetry

      def initialize binding, file_module
        @binding = binding
        @file_module = file_module
      end

      def self.build root_directory, telemetry=nil
        binding = TOPLEVEL_BINDING

        instance = new binding, File
        instance.telemetry = telemetry if telemetry
        instance
      end

      def add path
        paths << path
      end

      def call
        passing = true

        paths.each do |path|
          path_contents = file_module.read path

          begin
            binding.eval path_contents, path
          rescue => error
            passing = false
          ensure
            telemetry.file_executed path
          end
        end

        passing
      end

      def paths
        @paths ||= []
      end
    end
  end
end

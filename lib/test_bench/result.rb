module TestBench
  class Result < Telemetry
    def self.build
      instance = new [], 0, 0, 0, 0, 0

      if Settings.toplevel.record_telemetry
        instance.sink = []
      end

      instance
    end

    def asserted
      publish :asserted

      self.assertions += 1
    end

    def error_raised error
      self.errors += 1
      publish :error_raised, error
    end

    def failed?
      not passed?
    end

    def file_finished file
      files << file
      stopped
      publish :file_finished, file
    end

    def file_started file
      publish :file_started, file
    end

    def passed?
      failures.zero? and errors.zero?
    end

    def run_started
      started
      publish :run_started
    end

    def run_finished
      stopped
      publish :run_finished
    end

    def started
      self.start_time ||= clock.now
    end

    def stopped
      self.stop_time ||= clock.now
    end

    def test_failed prose
      self.failures += 1
      publish :test_failed, prose
    end

    def test_skipped prose
      self.skips += 1
      publish :test_skipped, prose
    end

    undef_method :failed
    undef_method :failed=

    module Assertions
      include Telemetry::Assertions

      def executed? *files
        files.all? do |control_file|
          sink.any? do |record|
            file = record.data
            control_file == file
          end
        end
      end
    end

  end
end

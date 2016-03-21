module TestBench
  class Result < Struct.new :files, :passes, :failures, :skips, :assertions, :errors, :start_time, :stop_time
    attr_writer :clock

    def self.build
      instance = new [], 0, 0, 0, 0, 0
      instance.started
      instance
    end

    def asserted
      self.assertions += 1
    end

    def clock
      @clock ||= Time
    end

    def elapsed_time
      stop_time - start_time
    end

    def error_raised error
      self.errors += 1
    end

    def failed?
      not passed?
    end

    def file_finished file
      files << file
    end

    def passed?
      failures.zero? and errors.zero?
    end

    def run_started
      started
    end

    def run_finished
      stopped
    end

    def started
      self.start_time ||= clock.now
    end

    def stopped
      self.stop_time ||= clock.now
    end

    def test_failed prose
      self.failures += 1
    end

    def test_passed prose
      self.passes += 1
    end

    def test_skipped prose
      self.skips += 1
    end

    def tests
      failures + passes + skips
    end

    def tests_per_second
      Rational tests, elapsed_time
    end

    module Null
      def self.method_missing *;
      end

      def self.respond_to? _
        true
      end
    end

    module Assertions
      def executed? *control_files
        control_files.all? do |control_file|
          files.include? control_file
        end
      end
    end
  end
end

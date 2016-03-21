module TestBench
  class Result < Struct.new :files, :passes, :failures, :skips, :assertions, :errors, :start_time, :stop_time
    include Observable

    attr_writer :clock

    def self.build
      new [], 0, 0, 0, 0, 0
    end

    def asserted
      publish :asserted

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

    def publish event, *arguments
      changed
      notify_observers event, *arguments
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

    def subscribe subscriber
      subscription = Telemetry::Subscription.new subscriber
      add_observer subscription
      subscription
    end

    def test_failed prose
      self.failures += 1
      publish :test_failed, prose
    end

    def test_passed prose
      self.passes += 1
      publish :test_passed, prose
    end

    def test_skipped prose
      self.skips += 1
      publish :test_skipped, prose
    end

    def tests
      failures + passes + skips
    end

    def tests_per_second
      Rational tests, elapsed_time
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

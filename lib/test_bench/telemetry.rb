module TestBench
  class Telemetry < Struct.new :files, :passes, :failures, :skips, :assertions, :errors, :start_time, :stop_time
    include Observable

    attr_writer :clock
    attr_accessor :failed
    attr_writer :nesting
    attr_writer :sink

    def self.build
      instance = new [], 0, 0, 0, 0, 0

      if Settings.toplevel.record_telemetry
        instance.sink = []
      end

      instance
    end

    def << other
      self.assertions += other.assertions
      self.errors += other.errors
      self.files.concat other.files
      self.failures += other.failures
      self.passes += other.passes
      self.skips += other.skips
      self.start_time = [start_time, other.start_time].compact.min
      self.stop_time = [stop_time, other.stop_time].compact.max
    end

    def + other
      result = self.dup
      result << other
      result
    end

    def asserted
      publish :asserted

      self.assertions += 1
    end

    def clock
      @clock ||= Time
    end

    def context_entered prose
      publish :context_entered, prose

      self.nesting += 1
    end

    def context_exited prose
      publish :context_exited, prose

      self.nesting -= 1

      nesting
    end

    def elapsed_time
      stop_time - start_time
    end

    def error_raised error
      self.failed = true

      publish :error_raised, error
    end

    def failed?
      if failed then true else false end
    end

    def file_finished file
      files << file
      stopped
      publish :file_finished, file
    end

    def file_started file
      publish :file_started, file
    end

    def nesting
      @nesting ||= 0
    end

    def passed?
      not failed?
    end

    def publish event, *arguments
      changed
      notify_observers event, *arguments
      sink << event
    end

    def run_started
      started
      publish :run_started
    end

    def run_finished
      stopped
      publish :run_finished
    end

    def sink
      @sink ||= NullSink
    end

    def started
      self.start_time ||= clock.now
    end

    def stopped
      self.stop_time ||= clock.now
    end

    def subscribe subscriber
      subscription = Subscription.new subscriber
      add_observer subscription
      subscription
    end

    def test_failed prose
      self.failed = true

      self.failures += 1
      publish :test_failed, prose
    end

    def test_finished prose
      publish :test_finished, prose
    end

    def test_passed prose
      self.passes += 1
      publish :test_passed, prose
    end

    def test_skipped prose
      self.skips += 1
      publish :test_skipped, prose
    end

    def test_started prose
      publish :test_started, prose
    end

    def tests
      failures + passes + skips
    end

    def tests_per_second
      Rational tests, elapsed_time
    end

    def self.subscribe subscriber
      toplevel_telemetry = Registry.get TOPLEVEL_BINDING
      toplevel_telemetry.subscribe subscriber
    end

    module NullSink
      extend Enumerable

      def self.<< event
      end

      def self.each &block
      end
    end
  end
end

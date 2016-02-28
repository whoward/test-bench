module TestBench
  class Telemetry < Struct.new :files, :passes, :failures, :skips, :assertions, :errors, :start_time, :stop_time
    attr_writer :clock
    attr_writer :output

    def self.build
      instance = new [], 0, 0, 0, 0, 0
      instance.started
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
      self.assertions += 1
    end

    def clock
      @clock ||= Time
    end

    def context_entered prose
      output.context_entered prose
    end

    def context_exited prose
      output.context_exited prose
    end

    def elapsed_time
      stop_time - start_time
    end

    def error_raised error
      self.errors += 1
      output.error_raised error
    end

    def failed?
      not passed?
    end

    def file_finished file
      files << file
      stopped
      output.file_finished file, self
    end

    def file_started file
      started
      output.file_finished file, self
    end

    def output
      @output ||= Output.new :verbose
    end

    def passed?
      failures.zero? and errors.zero?
    end

    def run_finished
      output.run_finished self
    end

    def started
      self.start_time = clock.now
    end

    def stopped
      self.stop_time = clock.now
    end

    def test_failed prose
      self.failures += 1
      output.test_failed prose
    end

    def test_passed prose
      self.passes += 1
      output.test_passed prose
    end

    def test_skipped prose
      self.skips += 1
      output.test_skipped prose
    end

    def test_started prose
      output.test_started prose
    end

    def tests
      failures + passes + skips
    end

    def tests_per_second
      Rational tests, elapsed_time
    end
  end
end

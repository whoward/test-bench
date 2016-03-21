module TestBench
  class Result < Telemetry
    undef_method :failed
    undef_method :failed=

    def error_raised error
      self.errors += 1
      publish :error_raised, error
    end

    def failed?
      not passed?
    end

    def passed?
      failures.zero? and errors.zero?
    end

    def test_failed prose
      self.failures += 1
      publish :test_failed, prose
    end
  end
end

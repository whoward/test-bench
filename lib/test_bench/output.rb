module TestBench
  class Output
    attr_accessor :force_color
    attr_writer :device
    attr_accessor :indentation
    attr_accessor :level
    attr_writer :nesting

    def initialize level
      @level = level
      @indentation = 0
    end

    def self.build
      level = :normal

      instance = new level
      instance.device = $stdout
      instance
    end

    def asserted
      result.asserted
    end

    def color_enabled?
      return force_color unless force_color.nil?
      return true if device.is_a? StringIO
      device.tty?
    end

    def context_entered prose
      if prose
        normal prose, :fg => :green
        indent
      end
    end

    def context_exited prose
      if prose
        deindent
        normal ' ' if indentation.zero?
      end
    end

    def deindent
      self.indentation -= 1 unless level == :quiet
    end

    def detail_error error
      detail_summary = "#{error.backtrace[0]}: #{error.message} (#{error.class})"

      quiet detail_summary, :fg => :red
      error.backtrace[1..-1].each do |frame|
        quiet "        from #{frame}", :fg => :red
      end
    end

    def device
      @device ||= StringIO.new
    end

    def error_raised error
      result.error_raised error

      indent
      detail_error error
      deindent
    end

    def file_finished file
      result.file_finished file
      result.stopped

      summary = summarize_result

      nesting.pop

      verbose "Finished running #{file}"
      verbose summary
      verbose ' '
    end

    def file_started file, file_result=nil
      normal "Running #{file}"

      file_result ||= Result.build
      file_result.started
      file_result.subscribe result

      result.file_started file
      nesting << file_result
    end

    def indent
      self.indentation += 1 unless level == :quiet
    end

    def lower_verbosity
      if level == :verbose
        self.level = :normal
      elsif level == :normal
        self.level = :quiet
      end
    end

    def nesting
      @nesting ||= [Result.build]
    end

    def normal prose, **colors
      write prose, **colors unless level == :quiet
    end

    def quiet prose, **colors
      write prose, **colors
    end

    def raise_verbosity
      if level == :quiet
        self.level = :normal
      elsif level == :normal
        self.level = :verbose
      end
    end

    def result
      nesting.fetch -1
    end

    def run_started
      result.run_started
    end

    def run_finished
      result.run_finished

      files_label = if result.files.size == 1 then 'file' else 'files' end

      quiet "Finished running #{result.files.size} #{files_label}"

      summary = summarize_result

      color = if result.passed? then :cyan else :red end

      quiet summary, :fg => color
    end

    def summarize_result
      minutes, seconds = result.elapsed_time.divmod 60

      elapsed = String.new
      elapsed << "#{minutes}m" unless minutes.zero?
      elapsed << "%.3fs" % seconds

      test_label = if result.tests == 1 then 'test' else 'tests' end
      error_label = if result.errors == 1 then 'error' else 'errors' end
      "Ran %d #{test_label} in #{elapsed} (%.3fs tests/second)\n%d passed, %d skipped, %d failed, %d total #{error_label}" %
        [result.tests, result.tests_per_second, result.passes, result.skips, result.failures, result.errors]
    end

    def test_failed prose
      result.test_failed prose

      quiet prose, :fg => :white, :bg => :red
    end

    def test_passed prose
      result.test_passed prose

      normal prose, :fg => :green
    end

    def test_skipped prose
      result.test_skipped prose

      normal prose, :fg => :brown
    end

    def test_started prose
      verbose "Started test #{prose.inspect}", :fg => :gray
    end

    def verbose prose, **colors
      write prose, **colors if level == :verbose
    end

    def write prose, **colors
      if color_enabled?
        prose = Palette.apply prose, **colors
      end

      prose = "#{'  ' * indentation}#{prose}"

      device.puts prose
    end
  end
end

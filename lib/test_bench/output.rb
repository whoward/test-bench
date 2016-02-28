module TestBench
  class Output
    attr_writer :device
    attr_accessor :indentation
    attr_accessor :level

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

    def context_entered prose
      if prose
        normal prose, :fg => :green
        indent
      end
    end

    def context_exited prose
      deindent if prose
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
      indent
      detail_error error
      deindent
    end

    def file_finished file, telemetry
      normal ' '

      summary = summarize_telemetry telemetry

      verbose "Finished running #{file}"
      verbose summary
      verbose ' '
    end

    def file_started file
      normal "Running #{file}"
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

    def run_finished telemetry
      files = if telemetry.files.size == 1 then 'file' else 'files' end

      quiet "Finished running #{telemetry.files.size} #{files}", :fg => :cyan

      summary = summarize_telemetry telemetry
      quiet summary, :fg => :cyan
    end

    def summarize_telemetry telemetry
      minutes, seconds = telemetry.elapsed_time.divmod 60

      elapsed = String.new
      elapsed << "#{minutes}m" unless minutes.zero?
      elapsed << "%.3fs" % seconds

      tests = if telemetry.tests == 1 then 'test' else 'tests' end

      "Ran %d #{tests} in #{elapsed} (%.3fs tests/second); %d passed, %d skipped, %d failed" %
        [telemetry.tests, telemetry.tests_per_second, telemetry.passes, telemetry.skips, telemetry.failures]
    end

    def test_failed prose
      normal prose, :fg => :white, :bg => :red
    end

    def test_passed prose
      normal prose, :fg => :green
    end

    def test_skipped prose
      normal prose, :fg => :brown
    end

    def test_started prose
      verbose "Started test #{prose.inspect}", :fg => :gray
    end

    def verbose prose, **colors
      write prose, **colors if level == :verbose
    end

    def write prose, **colors
      if device.tty? or device.is_a? StringIO
        prose = Palette.apply prose, **colors
      end

      prose = "#{'  ' * indentation}#{prose}"

      device.puts prose
    end

    def self.instance
      @instance ||= build
    end

    module Assertions
      def text_written
        device.rewind
        device.read
      end

      def wrote_line? text, indent: nil, **colors
        color ||= {}
        indent ||= 0

        color_escape = Palette.escape_code **colors
        unless color_escape.empty?
          text = "#{color_escape}#{text}\e[0m"
        end

        matcher = Regexp.escape "#{'  ' * indent}#{text}"

        pattern = /^#{matcher}$/n

        pattern.match text_written
      end

      def wrote_nothing?
        text_written.empty?
      end
    end
  end
end

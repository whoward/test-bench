module TestBench
  class Output
    attr_writer :device
    attr_accessor :indentation
    attr_reader :level

    def initialize level
      @level = level
      @indentation = 0
    end

    def self.build
      instance = new
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
      self.indentation -= 1
    end

    def detail_error error
      detail_summary = "#{error.backtrace[0]}: #{error.message} (#{error.class})"

      quiet detail_summary, :fg => :white, :bg => :red
      error.backtrace[1..-1].each do |frame|
        quiet "        from #{frame}", :fg => :white, :bg => :red
      end
    end

    def device
      @device ||= StringIO.new
    end

    def file_started path
      normal "Running #{path}"
    end

    def indent
      self.indentation += 1
    end

    def normal prose, **colors
      write prose, **colors unless level == :quiet
    end

    def quiet prose, **colors
      write prose, **colors if level == :quiet
    end

    def test_failed prose, error
      normal prose, :fg => :red

      indent
      detail_error error
      deindent
    end

    def test_passed prose
      normal prose, :fg => :green
    end

    def test_started prose
      verbose "Started test #{prose.inspect}"
    end

    def verbose prose, **colors
      write prose, **colors if level == :verbose
    end

    def write prose, **colors
      prose = Palette.apply prose, **colors
      prose = "#{'  ' * indentation}#{prose}"
      device.puts prose
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

module TestBench
  module Output
    class RenderError
      include Settings::SettingMacro

      include Format::Dependency

      setting :backtrace_filter
      def backtrace_filter
        @backtrace_filter ||= Settings::Data::Defaults.backtrace_filter
      end

      setting :reverse_backtraces

      def self.build(settings: nil)
        settings ||= Settings.instance

        instance = new
        settings.set(instance)
        Format.configure(instance, settings: settings)
        instance
      end

      def self.configure(receiver, settings: nil, attr_name: nil)
        attr_name ||= :render_error

        instance = build(settings: settings)

        receiver.public_send("#{attr_name}=", instance)

        instance
      end

      def call(error)
        output = []

        output << header(error)

        output += backtrace(error)

        output.reverse! if reverse_backtraces

        output.join
      end

      def header(error)
        header = String.new

        header << format.("#{error.backtrace[0]}: ", fg: :red)
        header << format.("#{error.message} (", fg: :red, style: :bold)
        header << format.(error.class.name, fg: :red, styles: [:bold, :underline])
        header << format.(")", fg: :red, style: :bold)
        header << "\n"

        header
      end

      def backtrace(error)
        backtrace = []

        error.backtrace[0..-1].each_cons(2).group_by do |prev_entry, entry|
          if backtrace_filter.match?(entry)
            if !backtrace_filter.match?(prev_entry)
              backtrace << "\t#{format.("from (filtered)", fg: :red)}\n"
            end
          else
            backtrace << "\t#{format.("from #{entry}", fg: :red)}\n"
          end
        end

        backtrace
      end
    end
  end
end

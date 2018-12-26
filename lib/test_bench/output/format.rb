module TestBench
  module Output
    class Format
      LabelError = Class.new(RuntimeError)

      def self.call(string, fg: nil, bg: nil, styles: nil, style: nil)
        instance = new
        instance.(string, fg: fg, bg: bg, styles: styles, style: style)
      end

      def self.configure(receiver, settings: nil, attr_name: nil)
        attr_name ||= :format
        settings ||= Settings.instance

        if settings.color
          instance = new
        else
          instance = Substitute.new
        end

        receiver.public_send("#{attr_name}=", instance)

        instance
      end

      def self.color_palette
        @palette ||= %i(black red green yellow blue magenta cyan white)
      end

      def self.styles
        @styles ||= {
          :none => 0,
          :bold => 1,
          :inverse => 3,
          :underline => 4,
          :strikethrough => 9
        }
      end

      def call(string, fg: nil, bg: nil, styles: nil, style: nil)
        styles = Array(styles)

        styles << style unless style.nil?

        output = String.new

        format = fg || bg || styles.any?

        if format
          escape_codes = []

          styles.each do |style|
            style = style_ordinal(style)

            escape_codes << style
          end

          unless fg.nil?
            escape_codes << 30 + color_offset(fg)
          end

          unless bg.nil?
            escape_codes << 40 + color_offset(bg)
          end

          output << "\e[#{escape_codes.join(';')}m"
        end

        output << string

        if format
          output << "\e[0m"
        end

        output
      end

      def color_offset(label)
        color_offset = self.class.color_palette.index(label)

        if color_offset.nil?
          raise LabelError, "Unknown color #{label.inspect} (Colors: #{self.class.color_palette.map(&:inspect).join(', ')})"
        end

        color_offset
      end

      def style_ordinal(label)
        self.class.styles.fetch(label) do
          raise LabelError, "Unknown style #{label.inspect} (Colors: #{self.class.styles.keys.map(&:inspect).join(', ')})"
        end
      end

      class Substitute < Format
        def call(string, fg: nil, bg: nil, style: nil, styles: nil)
          unless fg.nil?
            color_offset(fg)
          end

          unless bg.nil?
            color_offset(bg)
          end

          unless style.nil?
            style_ordinal(style)
          end

          string.dup
        end
      end
    end
  end
end

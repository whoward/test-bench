module TestBench
  class Telemetry
    module Record
      def self.included(cls)
        cls.class_exec do
          extend Signal
        end
      end

      def self.define(*attributes, caller_location: nil)
        caller_location ||= false

        if caller_location
          attributes << :caller_location
        end

        Struct.new(*attributes) do
          include Record

          if caller_location
            include CallerLocation
          end

          attr_accessor :time
        end
      end

      def signal
        self.class.signal
      end

      module CallerLocation
        def caller_file
          caller_location.path
        end

        def caller_line_number
          caller_location.lineno
        end
      end

      module Signal
        extend self

        def signal(constant_name=nil)
          constant_name ||= self.name

          *, constant_name = constant_name.split('::')

          signal = Signal.convert_pascal_case(constant_name)

          signal.to_sym
        end

        def self.convert_pascal_case(text)
          text.gsub(%r{(?:[a-z[:digit]]|\A)[A-Z]}) do |part|
            part.downcase!

            if part.length == 2
              part.insert(1, '_')
            end

            part
          end
        end
      end
    end
  end
end

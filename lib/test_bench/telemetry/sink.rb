module TestBench
  class Telemetry
    class Sink
      Error = Class.new(RuntimeError)

      def self.register(telemetry)
        instance = new
        telemetry.register_subscriber(instance)
        instance
      end

      def record(record)
        records << record
      end
      alias_method :send, :record

      def recorded?(signal=nil, &block)
        records = match_records(signal, &block)

        records.any?
      end
      alias_method :received?, :recorded?

      def recorded_once?(signal=nil, &block)
        records = match_records(signal, &block)

        records.one?
      end
      alias_method :received_once?, :recorded_once?

      def one_record(signal=nil, &block)
        records = match_records(signal, &block)

        if records.one?
          return records[0]
        elsif records.none?
          return nil
        else
          raise Error, "Multiple records matched (Signal: #{signal || '(none)'}, Block: #{block.nil? ? 'no' : 'yes'}, Records Matched: #{records.count})"
        end
      end

      def match_records(signal=nil, &block)
        block ||= proc { true }

        unless signal.nil?
          inner_block = block

          block = proc { |record|
            if record.signal == signal
              inner_block.(record)
            else
              false
            end
          }
        end

        records.select do |record|
          block.(record)
        end
      end

      def records
        @records ||= []
      end
    end
  end
end

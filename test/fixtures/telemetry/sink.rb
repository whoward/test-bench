module Test
  module Fixtures
    module Telemetry
      class Sink
        include Fixture

        attr_reader :sink

        def initialize(sink)
          @sink = sink
        end

        def self.call(sink, &block)
          instance = new(sink)

          block.(instance)
        end

        def assert_recorded(signal, file: nil, line_number: nil, &block)
          telemetry_record = sink.one_record(signal)

          context "Signal: #{signal.inspect}" do
            test "Recorded" do
              refute(telemetry_record.nil?)
            end

            unless file.nil?
              test "Caller file" do
                assert(telemetry_record.caller_file == file)
              end
            end

            unless line_number.nil?
              test "Caller line number" do
                assert(telemetry_record.caller_line_number == line_number)
              end
            end

            unless block.nil?
              instance_exec(telemetry_record, &block)
            end
          end
        end

        def refute_recorded(signal)
          telemetry_record = sink.one_record(signal)

          context "Signal: #{signal.inspect}" do
            test "Not recorded" do
              assert(telemetry_record.nil?)
            end
          end
        end
      end
    end
  end
end

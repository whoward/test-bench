module TestBench
  module Controls
    module Telemetry
      module Handler
        def self.example
          Example.new
        end

        def self.example_class(&block)
          Class.new do
            include TestBench::Telemetry::Handler

            class_exec(&block) unless block.nil?
          end
        end

        class Example
          include TestBench::Telemetry::Handler

          setting Settings::Name.example

          def records
            @records ||= []
          end

          attr_accessor :configured
          alias_method :configured?, :configured

          def configure
            self.configured = true
          end

          handle Record::SomeSignal do |some_signal|
            self.records << some_signal
          end

          def handled?(record)
            records.include?(record)
          end
        end
      end
    end
  end
end

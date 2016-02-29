module TestBench
  class Telemetry
    module Subscriber
      def update event, *arguments
        send event, *arguments if respond_to? event
      end
    end
  end
end

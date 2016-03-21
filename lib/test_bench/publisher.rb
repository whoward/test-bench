module TestBench
  module Publisher
    def self.included cls
      cls.send :include, Observable
    end

    def publish event, *arguments
      changed
      notify_observers event, *arguments
    end

    def subscribe subscriber
      subscription = Telemetry::Subscription.new subscriber
      add_observer subscription
      subscription
    end
  end
end

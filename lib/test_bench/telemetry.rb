module TestBench
  class Telemetry
    Error = Class.new(RuntimeError)

    def self.instance
      @telemetry ||= Telemetry.new
    end

    def self.register_subscriber(subscriber)
      instance.register_subscriber(subscriber)
    end

    def self.configure(receiver, attr_name: nil)
      attr_name ||= :telemetry

      instance = self.instance
      receiver.public_send("#{attr_name}=", instance)
      instance
    end

    def record(record, time=nil)
      time ||= ::Time.now

      record.time ||= time

      subscribers.each do |subscriber|
        subscriber.send(record)
      end
    end

    def register_subscriber(subscriber)
      if subscribers.include?(subscriber)
        raise Error, "Subscriber is already registered (Subscriber: #{subscriber.inspect})"
      end

      subscribers << subscriber
    end

    def subscriber?(subscriber)
      subscribers.include?(subscriber)
    end

    def subscribers
      @subscribers ||= []
    end
  end
end

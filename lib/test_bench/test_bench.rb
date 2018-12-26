module TestBench
  def self.activate(receiver=nil, subscribers: nil)
    receiver ||= TOPLEVEL_BINDING.receiver
    subscribers = Array(subscribers)

    if subscribers.empty?
      subscribers << Output::Handlers::Fixture.build
    end

    subscribers.each do |subscriber|
      Telemetry.register_subscriber(subscriber)
    end

    receiver.extend(Fixture)
  end
end

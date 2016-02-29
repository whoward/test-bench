module TestBench
  def self.activate
    TOPLEVEL_BINDING.receiver.extend Structure

    telemetry = Telemetry::Registry.get TOPLEVEL_BINDING
    telemetry.add_observer Output.instance
  end
end

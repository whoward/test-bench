module TestBench
  def self.activate
    TOPLEVEL_BINDING.receiver.extend Structure

    output = Output.instance
    telemetry = Telemetry::Registry.get TOPLEVEL_BINDING

    output.telemetry = telemetry
    telemetry.add_observer Output.instance
  end
end

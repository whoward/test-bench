module TestBench
  def self.activate
    TOPLEVEL_BINDING.receiver.extend Structure

    telemetry = Telemetry::Registry.get TOPLEVEL_BINDING
    telemetry.output = Output.instance
  end
end

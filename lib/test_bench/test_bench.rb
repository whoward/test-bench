module TestBench
  include Structure

  def self.activate
    toplevel_binding = TOPLEVEL_BINDING

    telemetry = Telemetry::Registry.get toplevel_binding
    telemetry.output = Output.instance

    toplevel_binding.receiver.extend TestBench
  end
end

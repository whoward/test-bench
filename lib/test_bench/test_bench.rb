module TestBench
  include Structure

  def self.activate
    Settings::Environment.(Settings.toplevel)

    toplevel_binding = TOPLEVEL_BINDING

    telemetry = Telemetry::Registry.get toplevel_binding
    telemetry.output = Output.instance

    toplevel_binding.receiver.extend TestBench
  end
end

module TestBench
  include Structure

  def self.activate
    settings = Settings.toplevel
    Settings::Environment.(settings)

    Output.instance.disable_color unless settings.color

    toplevel_binding = TOPLEVEL_BINDING

    telemetry = Telemetry::Registry.get toplevel_binding
    telemetry.output = Output.instance

    toplevel_binding.receiver.extend TestBench
  end
end

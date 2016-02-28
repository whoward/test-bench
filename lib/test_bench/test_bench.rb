module TestBench
  include Structure

  def self.activate
    settings = Settings.toplevel
    Settings::Environment.(settings)

    Output.instance.force_color = settings.color unless settings.color.nil?

    toplevel_binding = TOPLEVEL_BINDING

    telemetry = Telemetry::Registry.get toplevel_binding
    telemetry.output = Output.instance

    toplevel_binding.receiver.extend TestBench
  end
end

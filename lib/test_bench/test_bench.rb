module TestBench
  def self.activate
    # TestBench.activate can be called multiple times
    return if TOPLEVEL_BINDING.receiver.is_a? Structure

    # "Monkeypatch" assert, context, and test onto the main object
    TOPLEVEL_BINDING.receiver.extend Structure

    # Build the output instance that will be used to render all the test output
    output = Output.build

    # Settings can affect the output (verbosity & color), so we pass the output
    # object into the toplevel settings object.
    settings = Settings::Registry.get TOPLEVEL_BINDING
    settings.output = output

    # Telemetry pushes updates to output for display
    Telemetry.subscribe output
  end
end

require_relative '../../test_init'

context "Context" do
  context "Optional Prose Argument Omitted" do
    sink = TestBench::Telemetry::Sink.new

    telemetry_sink = Controls::Evaluate.() do
      context do
        #
      end
    end

    Test::Fixtures::Telemetry::Sink.(telemetry_sink) do |test|
      [:context_entered, :context_exited].each do |signal|
        test.assert_recorded(signal)
      end
    end
  end
end

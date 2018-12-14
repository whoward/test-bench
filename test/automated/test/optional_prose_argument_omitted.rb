require_relative '../../test_init'

context "Test" do
  context "Optional Prose Argument Omitted" do
    context "Test Passes" do
      telemetry_sink = Controls::Evaluate.() do
        test do
          assert(true)
        end
      end

      Test::Fixtures::Telemetry::Sink.(telemetry_sink) do |test|
        [:test_passed, :test_started, :test_finished].each do |signal|
          test.assert_recorded(signal) do |record|
            test "Does not include prose" do
              assert(record.prose.nil?)
            end
          end
        end
      end
    end

    context "Test Fails" do
      telemetry_sink = Controls::Evaluate.() do
        test do
          assert(false)
        end
      rescue TestBench::Assert::Failure
      end

      Test::Fixtures::Telemetry::Sink.(telemetry_sink) do |test|
        [:test_failed, :test_started, :test_finished].each do |signal|
          test.assert_recorded(signal) do |record|
            test "Does not include prose" do
              assert(record.prose.nil?)
            end
          end
        end
      end
    end
  end
end

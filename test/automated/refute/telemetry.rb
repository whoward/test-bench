require_relative '../../test_init'

context "Refute" do
  context "Telemetry" do
    caller_file = __FILE__

    context "Refutation Passes" do
      caller_line_number = __LINE__ + 3

      telemetry_sink = Controls::Evaluate.() do
        refute(false)
      end

      Test::Fixtures::Telemetry::Sink.(telemetry_sink) do |test|
        test.assert_recorded(:asserted, file: caller_file, line_number: caller_line_number)

        test.assert_recorded(:assertion_passed, file: caller_file, line_number: caller_line_number)

        test.refute_recorded(:assertion_failed)
      end
    end

    context "Refutation Fails" do
      failure = nil

      caller_line_number = __LINE__ + 4

      telemetry_sink = Controls::Evaluate.() do
        begin
          refute(true)
        rescue TestBench::Assert::Failure => failure
        end
      end

      Test::Fixtures::Telemetry::Sink.(telemetry_sink) do |test|
        test.assert_recorded(:asserted, file: caller_file, line_number: caller_line_number)

        test.assert_recorded(:assertion_failed, file: caller_file, line_number: caller_line_number) do |assertion_failed|
          test "Failure" do
            assert(assertion_failed.failure == failure)
          end
        end

        test.refute_recorded(:assertion_passed)
      end
    end
  end
end

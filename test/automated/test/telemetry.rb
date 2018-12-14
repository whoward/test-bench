require_relative '../../test_init'

context "Test" do
  context "Telemetry" do
    prose = Controls::Test::Prose.example

    caller_file = __FILE__

    context "Test Passes" do
      caller_line_number = __LINE__ + 3

      telemetry_sink = Controls::Evaluate.() do
        test "#{prose}" do
          #
        end
      end

      Test::Fixtures::Telemetry::Sink.(telemetry_sink) do |test|
        test.assert_recorded(:test_started, file: caller_file, line_number: caller_line_number)
        test.assert_recorded(:test_passed, file: caller_file, line_number: caller_line_number)
        test.assert_recorded(:test_finished, file: caller_file, line_number: caller_line_number)

        test.refute_recorded(:test_failed)
        test.refute_recorded(:test_skipped)
        test.refute_recorded(:error_raised)
      end
    end

    context "Test Fails" do
      error = Controls::Error.example

      caller_line_number = __LINE__ + 3

      telemetry_sink = Controls::Evaluate.() do
        test "#{prose}" do
          raise error
        end
      end

      Test::Fixtures::Telemetry::Sink.(telemetry_sink) do |test|
        test.assert_recorded(:test_started, file: caller_file, line_number: caller_line_number)
        test.assert_recorded(:test_failed, file: caller_file, line_number: caller_line_number)
        test.assert_recorded(:test_finished, file: caller_file, line_number: caller_line_number)

        test.refute_recorded(:test_passed)
        test.refute_recorded(:test_skipped)
      end
    end

    context "Test is Skipped" do
      caller_line_number = __LINE__ + 3

      telemetry_sink = Controls::Evaluate.() do
        test "#{prose}"
      end

      Test::Fixtures::Telemetry::Sink.(telemetry_sink) do |test|
        test.assert_recorded(:test_skipped, file: caller_file, line_number: caller_line_number)

        test.refute_recorded(:test_started)
        test.refute_recorded(:test_failed)
        test.refute_recorded(:test_passed)
        test.refute_recorded(:test_finished)
        test.refute_recorded(:error_raised)
      end
    end
  end
end

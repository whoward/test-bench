require_relative '../../test_init'

context "Context" do
  context "Telemetry" do
    prose = Controls::Context::Prose.example

    caller_file = __FILE__

    context "Block Does Not Raise Error" do
      caller_line_number = __LINE__ + 3

      telemetry_sink = Controls::Evaluate.() do
        context "#{prose}", telemetry: telemetry do
          #
        end
      end

      Test::Fixtures::Telemetry::Sink.(telemetry_sink) do |test|
        test.assert_recorded(:context_entered, file: caller_file, line_number: caller_line_number)
        test.assert_recorded(:context_exited, file: caller_file, line_number: caller_line_number)

        test.refute_recorded(:error_raised)
      end
    end

    context "Block Raises Error" do
      error = Controls::Error.example

      caller_line_number = __LINE__ + 3

      telemetry_sink = Controls::Evaluate.() do
        context "#{prose}", telemetry: telemetry do
          raise error
        end
      end

      Test::Fixtures::Telemetry::Sink.(telemetry_sink) do |test|
        test.assert_recorded(:error_raised, file: caller_file, line_number: caller_line_number) do |error_raised|
          test "Error" do
            assert(error_raised.error == error)
          end
        end

        test.assert_recorded(:context_entered, file: caller_file, line_number: caller_line_number)
        test.assert_recorded(:context_exited, file: caller_file, line_number: caller_line_number)
      end
    end
  end
end

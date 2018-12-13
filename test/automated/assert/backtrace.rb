require_relative '../../test_init'

context "Assert" do
  context "Backtrace" do
    caller_file = __FILE__
    caller_line_number = __LINE__ + 4

    begin
      Controls::Evaluate.() do
        assert(false)
      end
    rescue TestBench::Assert::Failure => failure
    end

    refute(failure.nil?)

    context "Deepest Entry" do
      entry = failure.backtrace[0]

      test "Refers to the callsite of the failed assertion" do
        comment("Entry: #{entry}")

        assert(entry.start_with?("#{caller_file}:#{caller_line_number}"))
      end
    end
  end
end

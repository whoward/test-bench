require_relative '../test_init'

context "Comment" do
  prose = Controls::Comment::Prose.example

  caller_file = __FILE__
  caller_line_number = __LINE__ + 3

  telemetry_sink = Controls::Evaluate.() do
    comment "#{prose}"
  end

  Test::Fixtures::Telemetry::Sink.(telemetry_sink) do |test|
    test.assert_recorded(
      :commented,
      file: caller_file,
      line_number: caller_line_number
    )
  end
end

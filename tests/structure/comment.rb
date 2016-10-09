require_relative '../test_init'

context "Comment" do
  test do
    binding = Controls::Binding.example
    telemetry = TestBench::Telemetry::Registry.get binding

    binding.eval 'comment "Some Comment"', __FILE__, __LINE__

    assert telemetry, &:recorded_comment?
  end
end

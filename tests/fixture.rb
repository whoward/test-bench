require_relative './test_init'

context "Defining a test fixture" do
  fixture_class = TestBench::Controls::Fixture::Example

  context "Fixture executes a context block" do
    fixture, telemetry = TestBench::Controls::Fixture.pair

    fixture.example_context

    test "Context block is executed on binding delegate" do
      events = telemetry.sink.map &:event

      assert events == %i(context_entered context_exited)
    end
  end

  context "Fixture executes a test block" do
    fixture, telemetry = TestBench::Controls::Fixture.pair

    fixture.example_test

    test "Context block is invoked on binding delegate" do
      events = telemetry.sink.map &:event

      assert events == %i(test_started test_passed test_finished)
    end
  end

  context "Fixture performs assertions" do
    fixture, telemetry = TestBench::Controls::Fixture.pair

    fixture.example_assertions

    test "Context block is invoked on binding delegate" do
      events = telemetry.sink.map &:event

      assert events == %i(asserted asserted)
    end
  end

  test "Structure is set to toplevel binding by default" do
    fixture = TestBench::Controls::Fixture.example

    assert fixture.structure == TOPLEVEL_BINDING.receiver
  end
end

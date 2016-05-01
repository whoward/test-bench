require_relative './test_init'

context "Test structure" do
  context "Assert" do
    test "Positive" do
      binding = Controls::Binding.example
      script = Controls::TestScript::Passing.example
      telemetry = TestBench::Telemetry::Registry.get binding

      binding.eval script, __FILE__, __LINE__

      assert telemetry, &:recorded_asserted?
    end

    test "Negative" do
      binding = Controls::Binding.example
      script = Controls::TestScript::Failing.example
      telemetry = TestBench::Telemetry::Registry.get binding

      begin
        binding.eval script, __FILE__, __LINE__
      rescue TestBench::Assert::Failed => error
      end

      assert error
      assert telemetry, &:recorded_asserted?
    end
  end

  context "Context" do
    test do
      binding = Controls::Binding.example
      telemetry = TestBench::Telemetry::Registry.get binding

      binding.eval 'context do end', __FILE__, __LINE__

      assert telemetry, &:recorded_context_entered?
      assert telemetry, &:recorded_context_exited?
    end

    test "Errors are recorded" do
      binding = Controls::Binding.example
      telemetry = TestBench::Telemetry::Registry.get binding

      begin
        binding.eval 'context do fail end', __FILE__, __LINE__
      rescue SystemExit => error
      end

      assert telemetry, &:recorded_error_raised?
    end

    test "The system exits immediately when abort on error is set" do
      binding = Controls::Binding.example
      settings = TestBench::Settings::Registry.get binding
      settings.abort_on_error = true

      begin
        binding.eval 'context do fail end', __FILE__, __LINE__
      rescue SystemExit => error
      end

      assert error
      refute error.success?
    end

    test "No block is supplied" do
      binding = Controls::Binding.example
      telemetry = TestBench::Telemetry::Registry.get binding

      binding.eval 'context', __FILE__, __LINE__

      refute telemetry, &:recorded_error_raised?
    end

    context "The outermost context exits unsuccessfully" do
      test "System exits immediately" do
        binding = Controls::Binding.example
        settings = TestBench::Settings::Registry.get binding

        begin
          binding.eval 'context do fail end', __FILE__, __LINE__
        rescue SystemExit => error
        end

        assert error
        refute error.success?
      end

      test "System does not exit immediately if exit is suppressed" do
        binding = Controls::Binding.example
        settings = TestBench::Settings::Registry.get binding

        begin
          binding.eval 'context :suppress_exit => true do fail end', __FILE__, __LINE__
        rescue SystemExit => error
        end

        refute error
      end
    end

    test "Prose must be a String" do
      binding = Controls::Binding.example
      settings = TestBench::Settings::Registry.get binding

      assert proc { binding.eval 'context Object.new do end', __FILE__, __LINE__ } do
        raises_error? TypeError
      end
    end
  end

  context "Refute" do
    test "Positive" do
      binding = Controls::Binding.example
      telemetry = TestBench::Telemetry::Registry.get binding

      binding.eval 'refute false', __FILE__, __LINE__

      assert telemetry, &:recorded_asserted?
    end

    test "Negative" do
      binding = Controls::Binding.example
      telemetry = TestBench::Telemetry::Registry.get binding

      begin
        binding.eval 'refute true', __FILE__, __LINE__
      rescue TestBench::Assert::Failed => error
      end

      assert error
      assert telemetry, &:recorded_asserted?
    end
  end

  context "Test" do
    test "Passing" do
      binding = Controls::Binding.example
      telemetry = TestBench::Telemetry::Registry.get binding

      binding.eval 'test "Some test" do end', __FILE__, __LINE__

      assert telemetry, &:recorded_test_started?
      assert telemetry, &:recorded_test_passed?
      assert telemetry, &:recorded_test_finished?
    end

    test "Failing" do
      binding = Controls::Binding.example
      telemetry = TestBench::Telemetry::Registry.get binding

      binding.eval 'test "Some test" do assert false end', __FILE__, __LINE__

      assert telemetry, &:recorded_test_failed?
    end

    test "Skipping" do
      binding = Controls::Binding.example
      telemetry = TestBench::Telemetry::Registry.get binding

      binding.eval 'test', __FILE__, __LINE__

      assert telemetry, &:recorded_test_skipped?
    end

    test %{Prose defaults to "Test"} do
      binding = Controls::Binding.example
      output = Controls::Output.attach binding
      telemetry = TestBench::Telemetry::Registry.get binding

      binding.eval 'test do end', __FILE__, __LINE__

      assert telemetry do
        test? 'Test'
      end
    end

    test "Prose must be a String" do
      binding = Controls::Binding.example
      settings = TestBench::Settings::Registry.get binding

      assert proc { binding.eval 'test Object.new do end', __FILE__, __LINE__ } do
        raises_error? TypeError
      end
    end
  end
end

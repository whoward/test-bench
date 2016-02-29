require_relative './test_init'

context "Test structure" do
  context "Assertions" do
    test "Positive" do
      binding = Controls::Binding.example
      telemetry = TestBench::Telemetry::Registry.get binding

      binding.eval 'assert true', __FILE__, __LINE__

      assert telemetry.assertions == 1
    end

    test "Negative" do
      binding = Controls::Binding.example
      telemetry = TestBench::Telemetry::Registry.get binding

      begin
        binding.eval 'assert false', __FILE__, __LINE__
      rescue TestBench::Assert::Failed => error
      end

      assert error
      assert telemetry.assertions == 1
    end
  end

  context "Context" do
    test do
      binding = Controls::Binding.example
      telemetry = TestBench::Telemetry::Registry.get binding

      binding.eval 'context do end', __FILE__, __LINE__

      assert telemetry.passed?
    end

    test "Errors are recorded" do
      binding = Controls::Binding.example
      telemetry = TestBench::Telemetry::Registry.get binding

      binding.eval 'context do fail end', __FILE__, __LINE__

      assert telemetry.errors == 1
    end

    test "The system exits immediately when fail fast is set" do
      binding = Controls::Binding.example
      settings = TestBench::Settings::Registry.get binding
      settings.fail_fast = true

      begin
        binding.eval 'context do fail end', __FILE__, __LINE__
      rescue SystemExit => error
      end

      assert error
      assert !error.success?
    end

    test "Indentation" do
      binding = Controls::Binding.example
      output = Controls::Output.attach binding

      binding.eval <<~RUBY, __FILE__, __LINE__
      context "Outer context" do
        context "Inner context" do end
      end
      RUBY

      assert output do
        wrote_line? 'Inner context', :fg => :green, :indent => 1
      end
    end
  end

  context "Test" do
    test do
      binding = Controls::Binding.example
      telemetry = TestBench::Telemetry::Registry.get binding

      binding.eval 'test "Some test" do end', __FILE__, __LINE__

      assert telemetry.passes == 1
    end

    test "Errors are recorded both as as test failures and errors" do
      binding = Controls::Binding.example
      telemetry = TestBench::Telemetry::Registry.get binding

      binding.eval 'test "Some test" do fail end', __FILE__, __LINE__

      assert telemetry.failures == 1
      assert telemetry.errors == 1
    end

    test %{Prose defaults to "Test"} do
      binding = Controls::Binding.example
      output = Controls::Output.attach binding

      binding.eval 'test do end', __FILE__, __LINE__

      assert output do
        wrote_line? "Test", :fg => :green
      end
    end

    test "Skipping test" do
      binding = Controls::Binding.example
      telemetry = TestBench::Telemetry::Registry.get binding

      binding.eval 'test', __FILE__, __LINE__

      assert telemetry.skips == 1
    end
  end
end

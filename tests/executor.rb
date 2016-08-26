require_relative './test_init'

context "Executor" do
  kernel_substitute = Controls::KernelSubstitute.example

  test "File execution" do
    binding = Controls::Binding.example
    files = [Controls::KernelSubstitute::TestScript::Passing.file]

    executor = TestBench::Executor.new binding, kernel_substitute
    executor.(files)

    assert executor.telemetry, &:recorded_file_started?
    assert executor.telemetry, &:recorded_file_finished?
  end

  context "Result" do
    test "All passing tests returns true" do
      binding = Controls::Binding.example
      files = [Controls::KernelSubstitute::TestScript::Passing.file]

      executor = TestBench::Executor.new binding, kernel_substitute
      result = executor.(files)

      assert result == true
    end

    test "An uncaught error causes the result to be false" do
      binding = Controls::Binding.example
      files = [Controls::KernelSubstitute::TestScript::Error.file]

      executor = TestBench::Executor.new binding, kernel_substitute
      result = executor.(files)

      assert result == false
    end
  end

  context "Files that include an __END__ part" do
    test do
      kernel_substitute.file_map['/end.rb'] = '__END__'

      binding = Controls::Binding.example
      executor = TestBench::Executor.new binding, kernel_substitute

      result = executor.(['/end.rb'])

      assert result == true
    end
  end
end

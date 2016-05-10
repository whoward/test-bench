require_relative '../test_init'

context "Proc subjects" do
  context "Asserting that an error was raised" do
    test "An error type isn't specified" do
      result = TestBench::Assert.(->{ fail }) do
        raises_error?
      end

      assert result
    end

    test "An instance of the expected error type was raised" do
      result = TestBench::Assert.(->{ fail }) do
        raises_error? RuntimeError
      end

      assert result
    end

    test "An instance of a subclass of the expected error was raised" do
      error_superclass = Class.new StandardError
      error_subclass = Class.new error_superclass

      begin
        TestBench::Assert.(->{ raise error_subclass }) do
          raises_error? error_superclass
        end
      rescue error_subclass => error
      end

      assert error
    end

    test "Error types that differ from expected remain uncaught" do
      expected_error_class = Class.new StandardError
      actual_error_class = Class.new StandardError

      begin
        TestBench::Assert.(->{ raise actual_error_class }) do
          raises_error? expected_error_class
        end
      rescue actual_error_class => error
      end

      assert error
    end
  end
end

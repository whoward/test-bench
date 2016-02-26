require_relative './test_init'

context "Assert" do
  test "Passing" do
    assert TestBench::Assert.(true)
  end

  test "Failing" do
    assert !TestBench::Assert.(false)
  end

  context "Block" do
    test "Instance (0-arity)" do
      result = TestBench::Assert.(:some_object) do
        self == :some_object
      end

      assert result
    end

    test "Using block parameter (1-arity)" do
      result = TestBench::Assert.(:some_object) do |subject|
        subject == :some_object
      end

      assert result
    end

    test "Failing" do
      result = TestBench::Assert.(:some_object) do
        self == :some_other_object
      end

      assert !result
    end
  end

  context "Assertions module" do
    example_class = Class.new do
      module Assertions
        def predicate?
          true
        end
      end
    end

    test do
      subject = example_class.new

      result = TestBench::Assert.(subject) do
        predicate?
      end

      assert result == true
    end

    test "Modules" do
      subject = example_class

      result = TestBench::Assert.(subject) do
        predicate?
      end

      assert result == true
    end

    context "Module can be overridden" do
      mod = Module.new do
        def other_predicate?
          true
        end
      end

      test do
        object = example_class.new

        result = TestBench::Assert.(object, mod) do
          other_predicate?
        end

        assert result == true
      end

      test "Existing module is not used" do
        object = example_class.new

        result = TestBench::Assert.(object, mod) do
          respond_to? :predicate?
        end

        assert result == false
      end
    end

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

          result = TestBench::Assert.(->{ raise error_subclass }) do
            raises_error? error_superclass
          end

          assert not(result)
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
  end
end

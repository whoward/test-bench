require_relative './test_init'

context "Assert" do
  test "Passing assertion returns true" do
    assert TestBench::Assert.(true)
  end

  test "Failing assertion returns false" do
    refute TestBench::Assert.(false)
  end

  context "Block form" do
    context "Instance evaluation (0-arity)" do
      test "Passing" do
        result = TestBench::Assert.(:some_object) do
          self == :some_object
        end

        assert result
      end

      test "Failing" do
        result = TestBench::Assert.(:some_object) do
          self == :some_other_object
        end

        refute result
      end
    end

    context "Referencing block parameter (1-arity)" do
      test "Passing" do
        result = TestBench::Assert.(:some_object) do |subject|
          subject == :some_object
        end

        assert result
      end

      test "Failing" do
        result = TestBench::Assert.(:some_object) do |subject|
          subject == :some_other_object
        end

        refute result
      end
    end
  end

  context "Assertions module" do
    example_class = Class.new do
      module Assertions
        def predicate?
          :some_true_value
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
          :some_true_value
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
  end
end

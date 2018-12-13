require_relative '../../test_init'

context "Assert" do
  context "Block Argument" do
    context "Block Returns Passing Value" do
      begin
        Controls::Evaluate.() do
          assert { true }
        end
      rescue TestBench::Assert::Failure => failure
      end

      test "Does not raise error" do
        assert(failure.nil?)
      end
    end

    context "Block Returns Failing Value" do
      begin
        Controls::Evaluate.() do
          assert { false }
        end
      rescue TestBench::Assert::Failure => failure
      end

      test "Raises error" do
        refute(failure.nil?)
      end
    end

    context "Positional Argument" do
      context "Given" do
        positional_argument = :some_argument

        yielded_value = nil

        begin
          Controls::Evaluate.() do
            assert(positional_argument) do |_yielded_value|
              yielded_value = _yielded_value
            end
          end
        rescue TestBench::Assert::Failure
        end

        test "Positional argument is yielded to block" do
          assert(yielded_value == positional_argument)
        end
      end

      context "Omitted" do
        yielded_value = nil

        begin
          Controls::Evaluate.() do
            assert do |_yielded_value|
              yielded_value = _yielded_value
            end
          end
        rescue TestBench::Assert::Failure
        end

        test "Nothing is yielded to block" do
          assert(yielded_value.nil?)
        end
      end
    end
  end
end
